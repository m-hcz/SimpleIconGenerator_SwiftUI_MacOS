//
//  Home.swift
//  SimpleIconGenerator
//
//  Created by M H on 29/01/2022.
//

import SwiftUI

struct Home: View {
	
	@StateObject var iconModel: IconViewModel = IconViewModel()
	
	@Environment(\.self) var env
	
	
    var body: some View {
        
		VStack(spacing: 15) {
			if let image = iconModel.pickedImage {
				// MARK: displaying image
				HStack {
					VStack {
						Image(nsImage: image)
							.resizable()
							.scaledToFill()
							.frame(width: 250, height: 250)
							.clipped()
							.onTapGesture(perform: iconModel.pickImage)
						Text("250x250")
					}
					.padding()
					
					
					VStack(alignment: .center) {
						Image(nsImage: image)
							.resizable()
							.scaledToFill()
							.frame(width: 20, height: 20)
							.clipped()
							.onTapGesture(perform: iconModel.pickImage)
						Text("20x20")
							.padding(.bottom)
						
						Image(nsImage: image)
							.resizable()
							.scaledToFill()
							.frame(width: 40, height: 40)
							.clipped()
							.onTapGesture(perform: iconModel.pickImage)
						Text("40x40")
							.padding(.bottom)
						
						Image(nsImage: image)
							.resizable()
							.scaledToFill()
							.frame(width: 80, height: 80)
							.clipped()
							.onTapGesture(perform: iconModel.pickImage)
						Text("80x80")
						
					} // v
					.padding(.trailing)
				} // h
				
				
				// MARK: generate button
				Button(action: {
					iconModel.generateIconSet()
				}, label: {
					HStack {
						Image(systemName: "laptopcomputer.and.arrow.down")
						Text("Generate Icon Set")
							
					} // h
					.foregroundColor(env.colorScheme == .dark ? .black : .white)
					.padding(.vertical, 8)
					.padding(.horizontal, 18)
					.background(.secondary, in: RoundedRectangle(cornerRadius: 10))
					
				}) // b
					.padding(.top, 10)
				
			} else {
				// MARK: add button
				VStack {
					HStack {
						VStack {
							Image(systemName: "app.gift")
								.resizable()
								.scaledToFill()
								.frame(width: 250, height: 250)
								.clipped()
								.onTapGesture(perform: iconModel.pickImage)
							Text("250x250")
						}
						.padding()
						
						
						VStack(alignment: .center) {
							Image(systemName: "app.gift")
								.resizable()
								.scaledToFill()
								.frame(width: 20, height: 20)
								.clipped()
								.onTapGesture(perform: iconModel.pickImage)
							Text("20x20")
							
								.padding(.bottom)
							
							Image(systemName: "app.gift")
								.resizable()
								.scaledToFill()
								.frame(width: 40, height: 40)
								.clipped()
								.onTapGesture(perform: iconModel.pickImage)
							Text("40x40")
								.foregroundColor(.gray.opacity(0.2))
								.padding(.bottom)
							
							Image(systemName: "app.gift")
								.resizable()
								.scaledToFill()
								.frame(width: 80, height: 80)
								.clipped()
								.onTapGesture(perform: iconModel.pickImage)
							Text("80x80")
							
						} // v
						.padding(.trailing)
					} // h
					.foregroundColor(.gray.opacity(0.3))
					VStack {
						Button(action: {
							iconModel.pickImage()
						}, label: {
							Image(systemName: "plus")
								.font(.system(size: 22, weight: .bold))
								.foregroundColor(env.colorScheme == .dark ? .black : .white)
								.padding(15)
								.background(.secondary, in: RoundedRectangle(cornerRadius: 10))
						}) // b
						
						// recommended size
						Text("1024 x 1024 is recommended!")
							.font(.caption2)
							.foregroundColor(.secondary)
							.padding(.bottom, 10)
							.frame(maxHeight: .infinity, alignment: .bottom)
					} // v
				} // hhh
				
			} // if
		} // v
		.frame(width: 400, height: 400)
		.buttonStyle(.plain)
		// MARK: alert
		.alert(iconModel.alertMsg, isPresented: $iconModel.showAlert, actions: {
			
		}) // alert
		// MARK: loading view
		.overlay {
			ZStack {
				if iconModel.isGenerating {
					Color.black
						.opacity(0.25)
					
					ProgressView()
						.padding()
						.background(.white, in: RoundedRectangle(cornerRadius: 10))
					// always lignt mode
						.environment(\.colorScheme, .light)
				} // if
			} // z
		} // overlay
		.animation(.easeInOut, value: iconModel.isGenerating)
		
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
		Home()
			.preferredColorScheme(.dark)
		Home()
			.preferredColorScheme(.light)

    }
}
