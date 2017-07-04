//
//  HMAC.swift
//  LetterboxdAPI
//
//  Created by Ryan Maxwell on 20/06/17.
//  Copyright © 2017 Letterboxd. All rights reserved.
//

import Foundation

public struct HMAC {

	public enum Algorithm {
		case sha1
		case md5
		case sha256
		case sha384
		case sha512
		case sha224

		public var algorithm: CCHmacAlgorithm {
			switch self {
			case .md5: return CCHmacAlgorithm(kCCHmacAlgMD5)
			case .sha1: return CCHmacAlgorithm(kCCHmacAlgSHA1)
			case .sha224: return CCHmacAlgorithm(kCCHmacAlgSHA224)
			case .sha256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
			case .sha384: return CCHmacAlgorithm(kCCHmacAlgSHA384)
			case .sha512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
			}
		}

		public var digestLength: Int {
			switch self {
			case .md5: return Int(CC_MD5_DIGEST_LENGTH)
			case .sha1: return Int(CC_SHA1_DIGEST_LENGTH)
			case .sha224: return Int(CC_SHA224_DIGEST_LENGTH)
			case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
			case .sha384: return Int(CC_SHA384_DIGEST_LENGTH)
			case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
			}
		}
	}

	// MARK: - Signing

	public static func sign(data: Data, withKey: Data, algorithm: Algorithm) -> String {
		let signature = UnsafeMutablePointer<UInt8>.allocate(capacity: algorithm.digestLength)
		defer { signature.deallocate(capacity: algorithm.digestLength) }

		data.withUnsafeBytes { dataBytes in
			key.withUnsafeBytes { keyBytes in
				CCHmac(algorithm.algorithm, keyBytes, key.count, dataBytes, data.count, signature)
			}
		}

		var hash = ""
		for i in 0 ..< algorithm.digestLength {
			hash += String(format: "%02X", signature[i])
		}
		return hash
	}
}
