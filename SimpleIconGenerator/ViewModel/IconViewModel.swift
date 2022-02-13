//
//  IconViewModel.swift
//  SimpleIconGenerator
//
//  Created by M H on 29/01/2022.
//

import SwiftUI

class IconViewModel: ObservableObject {
    
	// MARK: selected image
	@Published var pickedImage: NSImage?
	
	// MARK: loading and alerts
	@Published var isGenerating: Bool = false
	@Published var alertMsg: String = ""
	@Published var showAlert: Bool = false
	
	// MARK: icon set sizes
	@Published var iconSizes: [Int] = [16, 20, 29, 32, 40, 48, 55, 58, 60, 64, 66, 76, 80, 87, 88, 92, 100, 102, 120, 128, 152, 167, 172, 180, 196, 216, 234, 256, 512, 1024]
	// picking image using nsopen panel
	func pickImage() {
		let panel = NSOpenPanel()
		panel.title = "Choose a Picture"
		panel.showsResizeIndicator = true
		panel.showsHiddenFiles = false
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.allowedContentTypes = [.image, .png, .jpeg]
		
		if panel.runModal() == .OK {
			if let result = panel.url?.path {
				let image = NSImage(contentsOf: URL(fileURLWithPath: result))
				self.pickedImage = image
			} else {
				// error
			}
		}
	} // f
	
	func generateIconSet() {
		// MARK: select folder
		folderSelector { folderURL in
			self.isGenerating = true
			// MARK: creating AppIcon.appiconset folder in it
			let modifiedURL = folderURL.appendingPathComponent("AppIcon.appiconset")
			
			DispatchQueue.global(qos: .userInteractive).async {
				do {
					let manager = FileManager.default
					try manager.createDirectory(at: modifiedURL, withIntermediateDirectories: true, attributes: [:])
					
					// MARK: contents.json
					self.writeContentsFile(folderURL: modifiedURL.appendingPathComponent("Contents.json"))
					
					// MARK: generate icons
					if let pickedImage = self.pickedImage {
						self.iconSizes.forEach { size in
							let imageSize = CGSize(width: CGFloat(size), height: CGFloat(size))
							let imageURL = modifiedURL.appendingPathComponent("\(size).png")
							pickedImage.resiteImage(size: imageSize).writeImage(to: imageURL)
						}
					}
					
					DispatchQueue.main.async {
						self.isGenerating = false
						
						// MARK: save alert
						self.alertMsg = "Successfully generated!"
						self.showAlert.toggle()
					}
				}
				catch {
					print(error.localizedDescription)
					DispatchQueue.main.async {
						self.isGenerating = false
					}
				} // catch
			} // dispatch
			
			
		} // folder selector
		
		
	} // f
	
	func writeContentsFile(folderURL: URL) {
		do {
			let bundle = Bundle.main.path(forResource: "Contents", ofType: "json") ?? ""
			let url = URL(fileURLWithPath: bundle)
			
			try Data(contentsOf: url).write(to: folderURL, options: .atomic)
		}
		catch {
			print(error.localizedDescription)
		}
	} // f
	
	func folderSelector(completion: @escaping (URL) -> ()) {
		let panel = NSOpenPanel()
		panel.title = "Choose a Folder"
		panel.showsResizeIndicator = true
		panel.showsHiddenFiles = false
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = true
		panel.canChooseFiles = false
		panel.allowedContentTypes = [.folder]
		
		if panel.runModal() == .OK {
			if let result = panel.url?.path {
				completion(URL(fileURLWithPath: result))
			} else {
				// error
			}
		}
	} // f
}


// MARK: extension
extension NSImage {
	func resiteImage(size: CGSize) -> NSImage {
		
		// reduce scaling factor
		let scale = NSScreen.main?.backingScaleFactor ?? 1
		let newSize = CGSize(width: size.width / scale, height: size.height / scale)
		let newImage = NSImage(size: newSize)
		newImage.lockFocus()
		
		// draw image
		self.draw(in: NSRect(origin: .zero, size: newSize))
		
		newImage.unlockFocus()
		
		return newImage
	}
	
	// write resized image as PNG
	func writeImage(to: URL) {
		guard let data = tiffRepresentation, let representation = NSBitmapImageRep(data: data), let pngData = representation.representation(using: .png, properties: [:]) else {
			return
		}
		try? pngData.write(to: to, options: .atomic)
	}
}
