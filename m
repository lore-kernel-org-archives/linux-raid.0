From: "Simon Edwards" <simon.edwards@proprius.co.uk>
Subject: Suggested patch against raidtools
Date: Sun, 9 Mar 2003 23:46:54 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000601c2e696$2a24e8a0$05eb10ac@bongo2>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0007_01C2E696.2A24E8A0"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------=_NextPart_000_0007_01C2E696.2A24E8A0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hello,
	I know that mdadm appears to be in vogue at present, but for any
of you using the "raidtools" suite of programs, please find a patch
against raidtools-1.00.3. The patch addresses a couple of problems I
found in raidtools - mainly due to the coding assumption that only raid
devices "md0 - md9" would be used - if you try and use "md1" and "md10"
you'll get an error saying the device is already running.

	The patch also includes the --no-delay flag for mkraid which is
used to avoid the 5 second warning included when using the
--dangerous-no-resync option. I've found this useful for avoiding the
delay when using mkraid in scripts.

Regards,

Simon.


------=_NextPart_000_0007_01C2E696.2A24E8A0
Content-Type: application/x-gzip;
	name="raidtools-1.00.3.patch.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="raidtools-1.00.3.patch.gz"

H4sICJdcaz4AA3JhaWR0b29scy0xLjAwLjMucGF0Y2gApVRtT6NAEP5Mf8VIcpUKVMDWNm28eNHT
mJhqet6HSy4hK+wWIl3IAt41xv9+M0ARted9OEJ4mXnm2dmZZyeMhQB7wUoFisVhkaZJbrtDxxke
Ha4fyDQM3nnsjBVBxMMW0bNt++/xmuc4R7bj2u4YnOlsPJ15Y0Q0F5j07Jmm+e91Gia8J+BOZuPR
zJ2+Yzo9Bft4ah2Dic8JnJ72gK5YFvDIVR6nEk7AsSDiSVZ/hfy+XNHnvIYGEVNwAEEqRby6iBOO
vuWXq3P/7GZxcXU5fyEUqQq4LxLWhJtbh0z9kCds02Elc5qE/tuY1llmK8XCnS6kUzzfyKDjpH1O
Xdrn1Gv2qT2BXmctMGvdgv1g34Lbm9s7/8vy0v92t7xaXFrQf9mZBQ48W3VklRgFCQzCsvRfZ9uF
Ks6SZGO3Ecsm4h3aJLRM7aoYegUi3LY8Xc5m+0RXNnTdinShIZMrrtIyt5G6LgyFqf2WvVOtbiD1
nJBRg6T/xk/l9EYjy3XB9EbHluu10vkVkQaMA6ZW+QCekAr3CQapJxArP+IsnEOGNxoy+7Pkv4sa
VrVPgJEXKlhnBvrWoS/ZGstekw1IZEUsSz7v2S0cNR88+Cwo4kdu4AoIw0Lu9GbkA01bpUUK7D5V
xbyz7ks76nw0kSmUk8CEQq6UBfr5VxTFzQ+UBRQRr7LhssghFfApR+nBGHKO1jC34KxQiX1GxKXM
S8X3fkp9uxFKX8sTzjNjjD+mpsXC2Nu2eUCGjrvO8LmbaSkDODmpRoCjStnkSy4qG1OKbYYZU2w9
TPgjT2APz8AA+v1e+MEEI4Mfpx+NsBaye4a17v8fYm+p2ik2mbnezik29o7oeNOrOd9VPYIIdYaS
wvuVpPTDdaijHrCMi+/X1wMqoOJFqWQ1SzRSYbYx7kshOPY+iEy3ahXZWdHaddCrFlVrCdK0SDMu
Df0wU2mAa+QFK7DxuvposebMuNTIP33D/1NlBgAA

------=_NextPart_000_0007_01C2E696.2A24E8A0--


