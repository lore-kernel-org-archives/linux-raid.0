From: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Subject: SW-RAID 1 and kernel 2.4.18
Date: Tue, 26 Nov 2002 14:56:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, i have a running software raid 1. This consist of two ide devices hda
and hdc. The root filesystem is running on this raid array. The harddiscs
are installed in removable frames. 
The system seems to work correctly. But i get some errors. In the file
messages i found: 

linux kernel: hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error } 
linux kernel: hdc: dma_intr: error=0x84 { DriveStatusError BadCRC }

Are the removables frames my problem? If i remove the frames (connect the
ide direct to the cable) the system runs better. I could not find the
message above. 

If i start a stress test (lot of file copies) the raid array starts
sometimes a resync process. I can't find more information at messages-file. 

Where does this come from? Where i have to look to get information to
prevent this? And at last the system warns me at restart that my
raid-superblocks are not correct. 

How do i resolve this? 
If i connect the two ide devices to the same ide port (hda and hdb used for
raid array) i also get a message about invalid raid superblocks. 

Someone knows something about this?

Regards

Arnt Schepke


