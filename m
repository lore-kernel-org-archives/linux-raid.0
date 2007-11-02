From: berk walker <berk@panix.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Fri, 02 Nov 2007 11:36:00 -0500
Message-ID: <472B51F0.3080605@panix.com>
References: <20071030210721.386ca2fa@absurd> <1193781699.10336.585.camel@firewall.xsintricity.com> <472A0D7A.4040807@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472A0D7A.4040807@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Doug Ledford <dledford@redhat.com>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Doug Ledford wrote:
>>
>> device /dev/sda (hd0)
>> root (hd0,0)
>> install --stage2=/boot/grub/stage2 /boot/grub/stage1 (hd0) 
>> /boot/grub/e2fs_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst
>> device /dev/hdc (hd0)
>> root (hd0,0)
>> install --stage2=/boot/grub/stage2 /boot/grub/stage1 (hd0) 
>> /boot/grub/e2fs_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst
>>
>> That will install grub on the master boot record of hdc and sda, and in
>> both cases grub will look to whatever drive it is running on for the
>> files to boot instead of going to a specific drive.
>>
>
> No, it won't... it'll look for the first drive in the system (BIOS 
> drive 80h).  This means that if the BIOS can see the bad drive, but it 
> doesn't work, you're still screwed.
>
>     -hpa
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Depends how "bad" the drive is.  Just to align the thread on this -  If 
the boot sector is bad - the bios on newer boxes will skip to the next 
one.  But if it is "good", and you boot into garbage - - could be 
Windows.. does it crash?

b

