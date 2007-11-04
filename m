From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Sat, 03 Nov 2007 20:44:45 -0700
Message-ID: <472D402D.6040900@zytor.com>
References: <20071030210721.386ca2fa@absurd> <1193781699.10336.585.camel@firewall.xsintricity.com> <472A0D7A.4040807@zytor.com> <472B51F0.3080605@panix.com> <472D3A1C.800@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472D3A1C.800@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: berk walker <berk@panix.com>, Doug Ledford <dledford@redhat.com>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
>>>
>> Depends how "bad" the drive is.  Just to align the thread on this -  
>> If the boot sector is bad - the bios on newer boxes will skip to the 
>> next one.  But if it is "good", and you boot into garbage - - could be 
>> Windows.. does it crash?
> 
> Right, if the drive is dead almost every BIOS will fail over, if the 
> read gets a CRC or similar most recent BIOS will fail over, but if an 
> error-free read returns bad data, how can the BIOS know.
> 

Unfortunately the Linux boot format doesn't contain any sort of 
integrity check.  Otherwise the bootloader could catch this kind of 
error and throw a failure, letting the next disk boot (or another kernel.)

	-hpa
