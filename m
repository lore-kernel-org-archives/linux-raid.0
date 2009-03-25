From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID5 reshape problems
Date: Wed, 25 Mar 2009 21:11:53 +0100
Message-ID: <49CA9009.304@xunil.at>
References: <49CA787C.2090100@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CA787C.2090100@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Just as an addition while I am waiting desparately ...

here the section of dmesg:

sd 0:0:5:0: Device offlined - not ready after error recovery
sd 0:0:5:0: Device offlined - not ready after error recovery
sd 0:0:5:0: Device offlined - not ready after error recovery
sd 0:0:5:0: Device offlined - not ready after error recovery
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 42380636
raid5: Disk failure on sdf4, disabling device. Operation continuing on 5
devices
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 42379612
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 22929100
raid5:md2: read error not correctable (sector 5000560 on sdf4).
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 22929092
raid5:md2: read error not correctable (sector 5000552 on sdf4).
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 22929084
raid5:md2: read error not correctable (sector 5000544 on sdf4).
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 22929108
raid5:md2: read error not correctable (sector 5000568 on sdf4).
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 22928988
raid5:md2: read error not correctable (sector 5000448 on sdf4).
raid5:md2: read error not correctable (sector 5000456 on sdf4).
raid5:md2: read error not correctable (sector 5000464 on sdf4).
raid5:md2: read error not correctable (sector 5000472 on sdf4).
raid5:md2: read error not correctable (sector 5000480 on sdf4).
raid5:md2: read error not correctable (sector 5000488 on sdf4).
raid5:md2: read error not correctable (sector 5000496 on sdf4).
raid5:md2: read error not correctable (sector 5000504 on sdf4).
raid5:md2: read error not correctable (sector 5000512 on sdf4).
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdf, sector 22929060
raid5:md2: read error not correctable (sector 5000520 on sdf4).
raid5:md2: read error not correctable (sector 5000528 on sdf4).
raid5:md2: read error not correctable (sector 5000536 on sdf4).
end_request: I/O error, dev sdf, sector 1953519836
md: super_written gets error=-5, uptodate=0
sd 0:0:5:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
md: md2: reshape done.


