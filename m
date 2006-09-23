From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Memory issues with RAID5?
Date: Sat, 23 Sep 2006 11:43:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0609231137170.19546@coffee.psychology.mcmaster.ca>
References: <828780e3286b7b48b6be48cea9447f9d@swip.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <828780e3286b7b48b6be48cea9447f9d@swip.net>
Sender: linux-raid-owner@vger.kernel.org
To: Fredrik Lindgren <fli@swip.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I have an AMD K7 machine with an 8way RADI5 array on a Marvell based

K7 is pretty wimpy by today's standards - really the K8 was AMD's 
first solid, server-quality platform.  in addition, you appear to have 
it under pretty high memory pressure.

> controller (sata_mv). When data is coming in over the Gigabit nic and
> is written to disk, messages like the one below intermittently shows
> up on the console. Eventually the machine freezes solid (hardware reset
> required).

freezing solid was somewhat common in the K7 era, hence the comment about 
server-quality.

> kernel: md0_raid5: page allocation failure. order:0, mode:0x20

this is a straightforward memory shortage; you can probably avoid it 
by increasing min_free_kbytes.  for this kind of server, I also like 
to encourage the kernel to write file IO back to disk more promptly
than default:

# delay writing dirty blocks hoping to collect further writes (default 30s)
vm.dirty_expire_centisecs = 1000
# try writing back every 1s (default 500=5s)
vm.dirty_writeback_centisecs = 100
(/etc/sysctl.conf or other mechanism.)

(the default settings tend to stutter under high write load, since the kernel
will accumulate 30 seconds of dirty pages (gigabytes), and then frantically
try to write them out...)

> pdflush: page allocation failure. order:0, mode:0x20

right.  nothing buggy here, just poorly tuned.  need to figure out how 
to avoid getting this low on memory.  (you don't have swap disabled, do you?)

> [<c0184331>] reiserfs_sync_fs+0x2c/0x46

hmm.  reiserfs doesn't have a great rep for server-type stability either.
