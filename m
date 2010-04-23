From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes (was: Two degraded mirror
 segments recombined out of sync for massive data loss)
Date: Fri, 23 Apr 2010 14:18:57 -0400
Message-ID: <4BD1E491.3090603@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD1B7E8.9020602@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After some more testing it seems the problems with --incremental are
more deep and general.  I have found two steps that both appear to do
the wrong thing:

mdadm /dev/md0 --fail /dev/sdb
mdadm /dev/md0 --remove /dev/sdb

At this point mdadm -E /dev/sda shows that sdb has been removed, but
mdadm -E of /dev/sdb shows both disks are active and in sync still.  The
metadata of sdb should be updated when failed or removed if possible.

mdadm --incremental /dev/sdb

This goes ahead and adds the disk back to the array, despite the fact
that it has been explicitly removed.

Whether or not the superblock on sdb is updated when it is removed,
--incremental should NOT use it as long as mdadm -D /dev/md0 says that
disk is removed, at least not use it in /dev/md0.
