From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Softraid controllers and Linux
Date: Sun, 16 Apr 2006 13:58:18 -0400
Message-ID: <444285BA.6030009@tmr.com>
References: <541048249.20060403093652@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <541048249.20060403093652@2ka.mipt.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Klimov <klimov@2ka.mipt.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Klimov wrote:

>Hello linux-raid,
>
>  I have tried several cheap RAID controllers recently (namely,
>  VIA VT6421, Intel 6300ESB and Adaptec/Marvell 885X6081).
>  
>  VIA one is a PCI card, the second two are built in a Supermicro
>  motherboard (E7520/X6DHT-G).
>
>  The intent was to let the BIOS of the controllers make a RAID1
>  mirror of two disks independently of an OS to make redundant
>  multi-OS booting transparent. While DOS and Windows saw their
>  mirrors as a singular block device, Linux (FC5) accessed the
>  two drives separately on all adapters.
>
>  Is this a bug or a feature of the kernel driver support? (I did
>  not try vendors' binary drivers, if there are any).
>
>  
>
If I understand how Linux uses the drives, you have to make them raid 
manually. However, the nice thing about BIOS RAID is that it will boot 
the system if the first boot drive fails. If the drive fails hard the 
BIOS will go to the first functional drive and boot. But if you get a 
CRC error, some BIOS will try another and some will just fail.

Vendor dependent.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

