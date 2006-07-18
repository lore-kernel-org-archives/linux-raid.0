From: Neil Brown <neilb@suse.de>
Subject: Re: Problem with --manage
Date: Tue, 18 Jul 2006 16:26:36 +1000
Message-ID: <17596.32540.259148.940716@cse.unsw.edu.au>
References: <20060717112618.GA25114@scavenger.homeip.net>
	<17596.30157.166359.578894@cse.unsw.edu.au>
	<20060718060827.GA8314@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Benjamin Schieder on Tuesday July 18
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 18, blindcoder@scavenger.homeip.net wrote:
> Jul 16 16:59:37 ceres kernel: ide: failed opcode was: unknown
> Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
> Jul 16 16:59:37 ceres kernel: ide0: reset: success
> Jul 16 16:59:37 ceres kernel: hdb: status error: status=0x00 { }
> Jul 16 16:59:37 ceres kernel: ide: failed opcode was: unknown
> Jul 16 16:59:37 ceres kernel: end_request: I/O error, dev hdb, sector 488391932
> Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
> Jul 16 16:59:37 ceres kernel: hdb: status error: status=0x10 { SeekComplete }
> Jul 16 16:59:37 ceres kernel: ide: failed opcode was: 0xea
> Jul 16 16:59:37 ceres kernel: raid5: Disk failure on hdb8, disabling device. Operation continuing on 2 devices
> Jul 16 16:59:37 ceres kernel: hdb: drive not ready for command
> Jul 16 16:59:37 ceres kernel: RAID5 conf printout:
> Jul 16 16:59:37 ceres kernel:  --- rd:3 wd:2 fd:1
> Jul 16 16:59:37 ceres kernel:  disk 0, o:0, dev:hdb8
> Jul 16 16:59:37 ceres kernel:  disk 1, o:1, dev:hda8
> Jul 16 16:59:37 ceres kernel:  disk 2, o:1, dev:hdc8
> Jul 16 16:59:37 ceres kernel: RAID5 conf printout:
> Jul 16 16:59:37 ceres kernel:  --- rd:3 wd:2 fd:1
> Jul 16 16:59:37 ceres kernel:  disk 1, o:1, dev:hda8
> Jul 16 16:59:37 ceres kernel:  disk 2, o:1, dev:hdc8
> ---
> 
> Now, is this a broken IDE controller or harddisk? Because smartctl claims
> that everything is fine.
> 

Ouch indeed.  I've no idea whose 'fault' this is.  Maybe ask on
linux-ide.

> 
> I don't have a script log or something, but here's what I did from an initrd
> with init=/bin/bash
> 
> # < mount /dev /proc /sys /tmp >
> # < start udevd udevtrigger udevsettle >
> while read a dev c ; do
> 	[ "$a" != "ARRAY" ] && continue
> 	[ -e /dev/md/${dev##*/} ] || /bin/mknod $dev b 9 ${dev##*/}
> 	/sbin/mdadm -A ${dev}
> done < /etc/mdadm.conf

mdadm -As --auto=yes
should be sufficient

> 
> Personalities : [linear] [raid0] [raid1] [raid5] [raid4]
> md5 : inactive raid5 hda8[1] hdc8[2]
>       451426304 blocks level 5, 64k chunk, algorithm 2 [2/3] [_UU]

Ahh, Ok, make that

  mdadm -As --force --auto=yes

A crash combined with a drive failure can cause undetectable data
corruption.  You need to give --force to effectively acknowledge
that..

I should get mdadm to explain what is happening so that I don't have
to as much....

NeilBrown
