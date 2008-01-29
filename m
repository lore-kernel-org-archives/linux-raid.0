From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: [PATCH] Use new sb type
Date: Tue, 29 Jan 2008 10:37:12 +0100
Message-ID: <479EF3C8.7010509@rabbit.us>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479E232E.1030801@rabbit.us> <479E2DDA.5040102@dgreaves.com> <479EA6DE.9070503@dionic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479EA6DE.9070503@dionic.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Southerwood <ts@dionic.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Southerwood wrote:
> David Greaves wrote:
>>
>> IIRC Doug Leford did some digging wrt lilo + grub and found that 1.1 and 1.2
>> wouldn't work with them. I'd have to review the thread though...
>>
>> David
>> -
> 
> For what it's worth, that was my finding too. -e 0.9+1.0 are fine with
> GRUB, but  1.1 an 1.2 won't work under the filesystem that contains
> /boot, at least with GRUB 1.x (I haven't used LILO for some time nor
> have I tried the development GRUB 2).
> 
> The reason IIRC boils down to the fact that GRUB 1 isn't MD aware, and
> the only reason one can "get away" with using it on a RAID 1 setup at
> all is that the constituent devices present the same data as the
> composite MD device, from the start.
> 
> Putting an MD SB at/near the beginning of the device breaks this case
> and GRUB 1 doesn't know how to deal with it.
> 
> Cheers
> Tim
> -

I read the entire thread, and it seems that the discussion drifted away from 
the issue at hand. I hate flogging a dead horse, but here are my 2 cents:

First the summary:

* Currently LILO and GRUB are the only booting mechanisms widely available 
(GRUB2 is nowhere to be seen, and seems to be badly designed anyway)

* Both of these boot mechanisms do not understand RAID at all, so they can 
boot only off a block device containing a hackishly-readable filesystem (lilo: 
files are mappable, grub: a stage1.5 exists)

* The only raid level providing unfettered access to the underlying filesystem 
is RAID1 with a superblock at its end, and it has been common wisdom for years 
that you need RAID1 boot partition in order to boot anything at all.

The problem is that these three points do not affect any other raid level (as 
you can not boot from any of them in a reliable fashion anyway). I saw a 
number of voices that backward compatibility must be preserved. I don't see 
any need for that because:

* The distro managers will definitely RTM and will adjust their flashy GUIs to 
do the right thing by explicitly supplying -e 1.0 for boot devices

* A clueless user might burn himself by making a single root on a single raid1 
device. But wait - he can burn himself the same way by making the root a raid5 
device and rebooting.

Why do we sacrifice "the right thing to do"? To eliminate the possibility of 
someone shooting himself in the foot by not reading the manual?

Cheers
Peter
