From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Linux RAID metadata format docs?
Date: Fri, 21 Nov 2003 20:18:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FBEB94A.7070500@pobox.com>
References: <20031114185013.GA11930@gtf.org> <16312.25308.143873.280291@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16312.25308.143873.280291@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday November 14, jgarzik@pobox.com wrote:
> 
>>Do any docs exist, that describe the on-disk md format?
> 
> 
> Not to my knowledge, beyond source code.

Thanks.


> I don't see that knowledge of the RAID format is needed by the bios.
[...]
>  The boot sector tries to load a kernel or second-stage off "0x80" as
>  normal.   The kernel or second-stage understands raid and makes sure
>  the correct root is assembled.
> 
>  Some daemon monitors drives that fail, and attempts to over-write
>  sector 0 of any such drive that is a boot-candidate.
> 
> This wouldn't quite do the right thing if:
>   The "first" drive goes off line for some reason.
>   A new kernel/second-stage is installed on remaining drive(s).
>   machine is rebooted and "first" drive comes back online during the
>   boot.
> 
> The "first" drive will look OK, but will not have a current kernel on
> it.
> 
> Does any of this make sense?
> 
> Were you thinking of some RAID level other than RAID1?


All RAID levels, 1 and 5 particularly.  To me, it boils down to a 
choice:  support in the bootloader, and/or support in the BIOS.  If the 
BIOS vendor is willing to support the _Linux_ md format, it seems to me 
that's a more reliable place to handle booting and failover in RAID1 or 
5.  OTOH, while coordinating multiple boot loaders (since one must 
predict behavior of lilo/grub in all raid1/5 failure scenarios) seems 
much more difficult, but ultimate not specific to one vendor.

By tradition the BIOS/firmware is the software that loads the 
bootloader.  It feels like the right thing to me, for that to continue 
even in the face of RAID arrays.  Users of "fake RAID" (i.e. the vendors 
market it as RAID, even though it's really software RAID) are used to 
their RAID arrays being accessible as a BIOS device, as weird as that 
may be :)

	Jeff





