From: Mike Perry <mikepery@fscked.org>
Subject: Re: Hot adding active disk to RAID1?
Date: Sat, 7 Feb 2004 11:37:16 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040207173716.GA10996@fscked.org>
References: <20040207152948.GA17368@fscked.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040207152948.GA17368@fscked.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thus spake Mike Perry (mikepery@fscked.org):

> Well, this is probably a FAQ, but I've really looked around..
> Does anyone have any experience with using raidreconf for RAID1, or have
> a way to hotadd a disk and have it become active, instead of being a
> spare?

Ok, in my impatience I grew some balls.. As it turns out, the RAID1
superblock is (seemingly?) independent of the contents of the volume. So
I was able to simply mkraid --force /dev/md0, this time WITH a
failed-disk directive. Once this was done, I was able to mount /dev/md0
right away, no reformatting or anything needed.

Then I hot-added the failed-disk, and it seems to be synching properly.

And also this time the failed-disk wasn't mirrored to immediately either
(ie without the explicit hotadd).. I wonder why that happened the last
time I did this.. Maybe I just miswrote the raidtab on that occasion..
Or possibly the partition type was raid autodetect and after the reboot
the md driver saw this and decided to start mirroring, regardless of
raidtab?

Anyways, sorry for the spam, but I imagine at least one other poor sap
out there will find this useful ;)

P.S. I also looked at the src for raidreconf.. it in fact only supports
raid0 and 5, and seems to be nice enough to refuse to do anything if you
have a different raid level. So they got that going for them, which is
nice.

-- 
Mike Perry
Mad Computer Scientist
fscked.org evil labs
