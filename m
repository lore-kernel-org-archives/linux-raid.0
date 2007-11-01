From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Thu, 01 Nov 2007 11:57:24 -0700
Message-ID: <472A2194.9070408@zytor.com>
References: <20071030210721.386ca2fa@absurd>	 <1193781699.10336.585.camel@firewall.xsintricity.com>	 <472A0D7A.4040807@zytor.com> <1193941858.10336.659.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193941858.10336.659.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> 
> Correct, and that's what you want.  The alternative is that if the BIOS
> can see the first disk but it's broken and can't be used, and if you
> have the boot sector on the second disk set to read from BIOS disk 0x81
> because you ASSuMEd the first disk would be broken but still present in
> the BIOS tables, then your machine won't boot unless that first dead but
> preset disk is present.  If you remove the disk entirely, thereby
> bumping disk 0x81 to 0x80, then you are screwed.  If you have any drive
> failure that prevents the first disk from being recognized (blown fuse,
> blown electronics, etc), you are screwed until you get a new disk to
> replace it.
> 

What you want is for it to use the drive number that BIOS passes into it 
(register DL), not a hard-coded number.  That was my (only) point -- 
you're obviously right that hard-coding a number to 0x81 would be worse 
than useless.

	-hpa
