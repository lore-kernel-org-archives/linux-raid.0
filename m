From: Neil Brown <neilb@suse.de>
Subject: Re: Problem with --manage
Date: Tue, 18 Jul 2006 15:46:53 +1000
Message-ID: <17596.30157.166359.578894@cse.unsw.edu.au>
References: <20060717112618.GA25114@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Benjamin Schieder on Monday July 17
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 17, blindcoder@scavenger.homeip.net wrote:
> 
> /dev/md/0 on /boot type ext2 (rw,nogrpid)
> /dev/md/1 on / type reiserfs (rw)
> /dev/md/2 on /var type reiserfs (rw)
> /dev/md/3 on /opt type reiserfs (rw)
> /dev/md/4 on /usr type reiserfs (rw)
> /dev/md/5 on /data type reiserfs (rw)
> 
> I'm running the following kernel:
> Linux ceres 2.6.16.18-rock #1 SMP PREEMPT Sun Jun 25 10:47:51 CEST 2006 i686 GNU/Linux
> 
> and mdadm 2.4.
> Now, hdb seems to be broken, even though smart says everything's fine.
> After a day or two, hdb would fail:
> 
> Jul 16 16:58:41 ceres kernel: raid5: Disk failure on hdb3, disabling device. Operation continuing on 2 devices
> Jul 16 16:58:41 ceres kernel: raid5: Disk failure on hdb5, disabling device. Operation continuing on 2 devices
> Jul 16 16:59:06 ceres kernel: raid5: Disk failure on hdb7, disabling device. Operation continuing on 2 devices
> Jul 16 16:59:37 ceres kernel: raid5: Disk failure on hdb8, disabling device. Operation continuing on 2 devices
> Jul 16 17:02:22 ceres kernel: raid5: Disk failure on hdb6, disabling device. Operation continuing on 2 devices

Very odd... no other message from the kernel?  You would expect
something if there was a real error.

> 
> Strange enough, this never happens to the raid1 md0 device, so maybe I'm
> totally wrong about hdb failing after all.

Not too surprising - md0 is /boot and it is likely that you are doing
no IO to that filesystem.

> 
> The problem now is, the machine hangs after the last message and I can only
> turn it off by physically removing the power plug.

alt-sysrq-P  or alt-sysrq-T give anything useful?

Sounds like a device driver problem.

> 
> When I now reboot the machine, `mdadm -A /dev/md[1-5]' will not start the
> arrays cleanly. They will all be lacking the hdb device and be 'inactive'.
> `mdadm -R' will not start them in this state. According to
> `mdadm --manage --help' using `mdadm --manage /dev/md/3 -a /dev/hdb6'
> should add /dev/hdb6 to /dev/md/3, but nothing really happens.
> After some trying, I realised that `mdadm /dev/md/3 -a /dev/hdb6' actually
> works. So where's the problem? The help message? The parameter parsing code?
> My understanding?

I don't understand.  'mdadm --manage /dev/md/3 -a /dev/hdb6' is
exactly the same command as without the --manage.  Maybe if you
provide a log of exactly what you did, exactly what the messages were,
and exactly what the result (e.g. in /proc/mdstat) was.

NeilBrown
