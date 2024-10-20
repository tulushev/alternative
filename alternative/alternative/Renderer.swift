import Metal
import MetalKit
import simd

struct AppState {
  var translation: CGPoint = .zero
  var zoomLevel: CGFloat = 1.0
}

enum Constants {
  static let pixelFormat: MTLPixelFormat = .rgba16Float
}

struct ShaderStatePtrSize {
    let ptr: UnsafeRawPointer
    let size: Int
}

class Renderer {

  public let device: MTLDevice
  var appState = AppState()
  let commandQueue: MTLCommandQueue
  var pipelineState: MTLRenderPipelineState

  init(device: MTLDevice) {
    self.device = device
    let queue = self.device.makeCommandQueue()!
    self.commandQueue = queue

    let library = device.makeDefaultLibrary()

    let vertexFunction = library?.makeFunction(name: "main_vs")
    let fragmentFunction = library?.makeFunction(name: "main_fs")

    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction

    pipelineDescriptor.colorAttachments[0].pixelFormat = Constants.pixelFormat

    pipelineState = try! device.makeRenderPipelineState(
      descriptor: pipelineDescriptor
    )
  }

  func draw(renderPassDescriptor: MTLRenderPassDescriptor) -> MTLCommandBuffer? {
    guard let commandBuffer = commandQueue.makeCommandBuffer() else { return nil }

    var shaderState = ShaderState(
      translation: vector_float2(Float(appState.translation.x), Float(appState.translation.y)),
      zoomLevel: Float(appState.zoomLevel)
    )
    let stateBuffer = device.makeBuffer(bytes: &shaderState, length: MemoryLayout<ShaderState>.stride, options: [])

    guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return nil }

    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setFragmentBuffer(stateBuffer, offset: 0, index: 0)
    renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
    renderEncoder.endEncoding()

    return commandBuffer
  }

  public func handlePanGesture(translation: CGPoint) {
    appState.translation.x += translation.x * appState.zoomLevel
    appState.translation.y += translation.y * appState.zoomLevel
  }

  public func handlePinchGesture(scale: CGFloat, location: CGPoint) {
    let previousZoomLevel = appState.zoomLevel
    appState.zoomLevel /= scale

    let deltaTranslation = CGPoint(
      x: location.x * (previousZoomLevel - appState.zoomLevel),
      y: location.y * (previousZoomLevel - appState.zoomLevel)
    )

    appState.translation.x += deltaTranslation.x
    appState.translation.y += deltaTranslation.y
  }
}

extension CGPoint {
  static let flipX = Self(x: -1.0, y: 1.0)
  static let flipY = Self(x: 1.0, y: -1.0)
  static let flip = Self(x: -1.0, y: -1.0)

  init(_ value: CGFloat) {
    self.init(x: value, y: value)
  }
}

func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  .init(
    x: lhs.x * rhs.x,
    y: lhs.y * rhs.y
  )
}

func * (point: CGPoint, float: CGFloat) -> CGPoint {
  .init(
    x: point.x * float,
    y: point.y * float
  )
}

func * (float: CGFloat, point: CGPoint) -> CGPoint {
  .init(
    x: point.x * float,
    y: point.y * float
  )
}
