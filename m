From: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Subject: fsck on raidvolumes at boot
Date: Sat, 10 May 2003 20:18:30 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.OSF.4.51.0305102009550.135362@soul.helsinki.fi>
References: <871y0ejtdf.fsf@jumper.lonesom.pp.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871y0ejtdf.fsf@jumper.lonesom.pp.fi>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello All!

When making an unclean shutdown/reset of the system, Linux normally checks
the disk partitions at boot with fsck (e2fsck). For raided mounts this
does not happen however, instead only a warning message of "unclean
partition mounted" (or similar) appears, as fstab is read and, say,
/dev/md0 gets mounted to, say, /wrk.

Is there a way to make Linux automatically check the /dev/md*'s before
mounting them if they are dirty?

I'm using Debian 3.0 and raidtools2.

Have a nice weekend,
    Mikael J.
    http://www.helsinki.fi/~mpjohans/
