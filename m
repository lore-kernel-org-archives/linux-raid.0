From: Tim Small <tim@semantico.com>
Subject: Re: raid-1 with  ide-scsi emulation and mkswap failure
Date: Thu, 15 Apr 2004 15:07:15 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <407E9713.2080607@semantico.com>
References: <007401c422f0$baec4bc0$b100000a@M145Primary>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <007401c422f0$baec4bc0$b100000a@M145Primary>
To: Eric Wood <eric@interplas.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eric Wood wrote:

>I did Warren's RAID-1 howto:
>http://togami.com/~warren/guides/remoteraidcrazies/
>===========
>1.  On this system I raid-1 /dev/hda and /dev/hdc together.
>
>And I'm getting these errors during the copy process.
>hdc: dma_intr: error=0x84 { DriveStatusError BadCRC }
>hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
>  
>
If you haven't already, then it may be worth checking the output of 
smartctl -a /dev/hdc  - just to satisfy yourself that the drive is 
feeling happy with itself...

http://smartmontools.sourceforge.net/

Tim.

