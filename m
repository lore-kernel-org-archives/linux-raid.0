From: Neil Brown <neilb@suse.de>
Subject: Re: 5 HDD RAID5 not starting after controller failure
Date: Sun, 3 Jun 2007 20:32:29 +1000
Message-ID: <18018.39101.44096.914966@notabene.brown>
References: <20070603094714.GI22122@soohrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Karsten Desler on Sunday June 3
Sender: linux-raid-owner@vger.kernel.org
To: Karsten Desler <kdesler@soohrt.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 3, kdesler@soohrt.org wrote:
> Hello,
> 
> I have a RAID5 that recently failed. sda-sdd are on the same SATA controller and
> every thing was running fine, until Linux decided it was a good idea to disable
> the controllers interrupt. After a reboot the RAID isn't starting anymore.
> 
> Before I do something stupid, I wanted to ask if the following command will
> probably restore the array with minimal data corruption.
> 
>   mdadm --assemble /dev/md6 --run --force /dev/sda8 /dev/sdb8 /dev/sdc8 /dev/sdd8
>   mdadm /dev/md6 -a /dev/sde1
> 
> Looking at the events counter, sda-sdc agree and sdd is very close so I'd guess
> that I have the best chances at getting as little corruption as possible. Or does
> it make more sense to start it with all disks active?

It looks like the data is almost certainly all completely uptodate.
The array was clean at event 253660.
A pending write caused md to try to update all the superblocks to
event 253661.  This worked on d8 and e1 but failed on [abc]8.
So md tried to update the superblocks on the others to record the
failure.
This worked on e1 but not [abcd]8, so d1 ended up with an event count
of  253664 (253663 marked the failures, and 253664 marked that there
were no incomplete writes).

So I would just
  mdadm -ARf /dev/md6 /dev/sd[abcd]8 /dev/sde1
and let mdadm pick the best drives.  Then add the remaining one in as
a hot-add.

NeilBrown
