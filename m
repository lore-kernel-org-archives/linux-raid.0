From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Sun, 16 Apr 2006 21:39:34 -0300
Message-ID: <17474.58310.249427.460602@fisica.ufpr.br>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	<17474.51121.178492.61143@cse.unsw.edu.au>
	<62b0912f0604161721xc30e6abn27c55dcd9caefd2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604161721xc30e6abn27c55dcd9caefd2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich (molle.bestefich@gmail.com) wrote on 17 April 2006 02:21:
 >Neil Brown wrote:
 >> use --assemble --force
 >
 ># mdadm --assemble --force /dev/md1
 >mdadm: forcing event count in /dev/sda1(0) from 163362 upto 163368
 >mdadm: /dev/md1 has been started with 5 drives (out of 6).
 >
 >Oops, only 5 drives, but I know data is OK on all 6 drives.
 >
 >I also know that there are bad blocks on more than 1 drive.  So I want
 >MD to recover from the other drives in those cases, which I won't be
 >able to with only 5 drives.
 >
 >In other words, checking/repairing with only 5 drives will lead to
 >data corruption.
 >
 >I'll stop and try again, listing all 6 drives by hand:
 >
 ># mdadm --stop /dev/md1
 ># mdadm --assemble /dev/md1 --force  /dev/sda1 /dev/sdb1 /dev/sdc1
 >/dev/sdd1 /dev/sde1 /dev/sdf1
 >mdadm: /dev/md1 has been started with 5 drives (out of 6).
 >
 >Ugh.  Didn't work.  Bug?
 >
 >How do I force MD to raise the event counter on sdb1 and accept it
 >into the array as-is, so I can avoid bad-block induced data
 >corruption?

There's something strange going on. As far as I understand when the
first read failure happens, with a non-degraded array, the (recent)
kernel doesn't kick the disk out, it recovers the info from the parity
and tries to write back the stripe on the failed disk so that it has a
chance to remap the sectors. Only if the write fails it kicks the disk
out.

When the array is degraded the first read failure cannot be recovered,
so the disk is (I suppose) excluded immediately and the whole array
stops. This means that the superblocks will have different values and
mdadm won't assemble back all of the 6 units, it'll try to reconstruct
the first failed one.

I don't know how to assemble everything back together in this case.
