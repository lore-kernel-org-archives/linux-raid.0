From: Steven Dake <sdake@mvista.com>
Subject: Re: SW-RAID 1 and kernel 2.4.18
Date: Tue, 26 Nov 2002 12:33:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DE3CC8D.2080104@mvista.com>
References: <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Schep,

IDE was not designed to hotswap.  The trays are not "hot swappable" in 
that they can only be swapped while the system is off.

For hotswap support, look to SCSI or even better, FibreChannel.  These 
systems are designed to be electrically safe in hotswap operations and 
maintain the integrity of the data transfers.

Thanks
-steve

SCHEP. - Schepke, Arnt wrote:

>Hi, i have a running software raid 1. This consist of two ide devices hda
>and hdc. The root filesystem is running on this raid array. The harddiscs
>are installed in removable frames. 
>The system seems to work correctly. But i get some errors. In the file
>messages i found: 
>
>linux kernel: hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error } 
>linux kernel: hdc: dma_intr: error=0x84 { DriveStatusError BadCRC }
>
>Are the removables frames my problem? If i remove the frames (connect the
>ide direct to the cable) the system runs better. I could not find the
>message above. 
>
>If i start a stress test (lot of file copies) the raid array starts
>sometimes a resync process. I can't find more information at messages-file. 
>
>Where does this come from? Where i have to look to get information to
>prevent this? And at last the system warns me at restart that my
>raid-superblocks are not correct. 
>
>How do i resolve this? 
>If i connect the two ide devices to the same ide port (hda and hdb used for
>raid array) i also get a message about invalid raid superblocks. 
>
>Someone knows something about this?
>
>Regards
>
>Arnt Schepke
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

