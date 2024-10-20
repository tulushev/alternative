import Cocoa

class MetalLayerView: NSView, CALayerDelegate {
  var renderer : Renderer
  var metalLayer : CAMetalLayer!

  override init(frame: NSRect) {
    renderer = Renderer(device: MTLCreateSystemDefaultDevice()!)

    super.init(frame: frame)

    self.wantsLayer = true
    self.layerContentsRedrawPolicy = .duringViewResize
    self.layerContentsPlacement = .scaleAxesIndependently

    self.addGestureRecognizer(NSPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    self.addGestureRecognizer(NSMagnificationGestureRecognizer(target: self, action: #selector(handlePinchGesture)))
  }

  @objc func handlePanGesture(sender: NSPanGestureRecognizer) {
    renderer.handlePanGesture(
      translation: sender.translation(in: self)
      * .flipX
      * (self.window?.backingScaleFactor ?? 1.0)
    )
    sender.setTranslation(.zero, in: self)
    self.setNeedsDisplay(self.bounds)
  }

  @objc func handlePinchGesture(sender: NSMagnificationGestureRecognizer) {
    let locationInPoints = sender.location(in: self)

    let locationInPixels = CGPoint(
      x: locationInPoints.x,
      y: (self.bounds.height - locationInPoints.y)
    ) * (self.window?.backingScaleFactor ?? 1.0)

    renderer.handlePinchGesture(
      scale: (1.0 + sender.magnification),
      location: locationInPixels
    )
    sender.magnification = 0.0
    self.setNeedsDisplay(self.bounds)
  }

  override func scrollWheel(with event: NSEvent) {
    renderer.handlePanGesture(
      translation: CGPoint(
        x: event.scrollingDeltaX,
        y: event.scrollingDeltaY
      ) * .flip
    )
    self.setNeedsDisplay(self.bounds)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeBackingLayer() -> CALayer {
    metalLayer = CAMetalLayer()
    metalLayer.pixelFormat = Constants.pixelFormat
    metalLayer.device = renderer.device
    metalLayer.delegate = self

    metalLayer.allowsNextDrawableTimeout = false

    // Crucial for resizing to work
    metalLayer.autoresizingMask = CAAutoresizingMask(arrayLiteral: [.layerHeightSizable, .layerWidthSizable])
    metalLayer.needsDisplayOnBoundsChange = true
    metalLayer.presentsWithTransaction = true

    return metalLayer
  }

  override func setFrameSize(_ newSize: NSSize) {
    super.setFrameSize(newSize)
    metalLayer.drawableSize = convertToBacking(newSize)
    self.viewDidChangeBackingProperties()
  }

  override func viewDidChangeBackingProperties() {
    guard let window = self.window else { return }
    metalLayer.contentsScale = window.backingScaleFactor
  }

  func display(_ layer: CALayer) {
    let drawable = metalLayer.nextDrawable()!

    let passDescriptor = MTLRenderPassDescriptor()
    let colorAttachment = passDescriptor.colorAttachments[0]!
    colorAttachment.texture = drawable.texture
    colorAttachment.loadAction = .clear
    colorAttachment.storeAction = .store
    colorAttachment.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)

    let commandBuffer: MTLCommandBuffer = renderer.draw(renderPassDescriptor: passDescriptor)!
    commandBuffer.commit()
    commandBuffer.waitUntilScheduled()
    drawable.present()
  }
}
