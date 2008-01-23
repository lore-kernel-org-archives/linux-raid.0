From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: performance of raid10,f2 on 4 disks
Date: Wed, 23 Jan 2008 19:21:20 +0100
Message-ID: <20080123182120.GA26044@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have played around with raid10,f2 on a 2 disk array set,
and I really liked the performance on the sequential reads.
It looked like double up on the speed, about 173 MB/s
for two SATA-2 disks. 

I then went on to look at my 4 new SATS-2 disks, to have
the same kind of performance I made the array by:

mdadm --create /dev/md3 --chunk=256 -R -l 10 -n 4 -p f2 /dev/sd[abcd]1

And my first tests showed a sequential read rate of 320 MB/s.
Impressive! I then tried it a few more times, but then I could not
get more than around 160 MB/s, which is less than what I got on 2 disks.

Any ideas of what is going on?

Best regards
keld
