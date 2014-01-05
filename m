From: Fabian Knorr <knorrfab@fim.uni-passau.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sun, 05 Jan 2014 11:40:11 +0100
Message-ID: <1388918411.3591.18.camel@vessel>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org>
	 <1388873143.7641.20.camel@vessel> <52C8C433.5030403@turmel.org>
	 <1388912870.3591.4.camel@vessel> <20140105205612.093276ef@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140105205612.093276ef@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I haven't read the whole thread, but this sounds like the bug fixed by:
> 
> commit f81a2b56c4b437f66aaf5582a9c6b7f5ab2103c4
> Author: NeilBrown <neilb@suse.de>
> Date:   Tue Oct 22 09:55:04 2013 +1100
> 
>     Assembe: fix bug in force_array - it wasn't forcing properly.
> 
> 
> try getting mdadm from git and building that
>   git clone git://neil.brown.name/mdadm
>   cd mdadm
>   make

Thank you Neil, that did it. 

With the git version, I was able to re-assemble the array as Phil told
me:

	mdadm --assemble /dev/md0 /dev/sd[bcefghi] --force --verbose

mdadm told me that "7 devices are not enough to start the array" (see
assemble.log). /proc/mdstat still showed /dev/md127 instead of md0, now
correctly with 7 drives and r/o (mdstat.log).

Still, I was able to see my LVM volumes after "vgchange -ay" and do a
(read-only) fsck (fsck.log). It seemed to pass flawlessly for the volume
"lvm-storage", which is the partition containing my data. "lvm-root"
failed horribly, but this is just the system partition which I planned
on re-building from scratch anyway.


I'd like to keep the state of lvm-storage as it is and re-install my
system. Still, a few things I'm not sure about:

	- How can I get mdadm to initiate resync and get write access 
	  to my data?

	- As lvm-root seems to be severly damaged, is there any chance
	  of  errors in the lvm-storage FS that fsck -fn does not
	  detect? Could re-syncing therefore destroy data I have access
	  to now?

	- Can I make sure that the working setup is written to all 
	  superblocks, and zero the spare's superblock so that there is
	  no such confusion when trying to assemble the array in the
	  future?

Thanks.

Fabian



