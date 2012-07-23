From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Mon, 23 Jul 2012 19:03:21 +0200
Message-ID: <20120723170320.GA2691@lazy.lzy>
References: <500CD32E.4000800@hardwarefreak.com>
 <542194327.593466.1343036057599.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <542194327.593466.1343036057599.JavaMail.root@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

actually, what you would like to do is already
possible, albeit it will kill the performance
of a rotating, mechanical, HDD.
With SSD might work better.

If you take an HDD and partition it, let's say
with 100 partitions (GPT will be required),
then you can build a RAID-6 using this 100
partitions, having a redundancy of 2%.
Taking two, or more, of such configured RAID-6,
it will be possible to build (with them) a
RAID-1 (or else).

If a check of this RAID-1 returns mismatches,
it will be possible to check the single devices
and find out which is not OK.
With RAID-6 (per device), and a bit of luck, it
will be possible to fix it directly.

Of course a lot of variables are tunable here.
For example the number of partitions, the chunk
size, or even the fact that with X partitions
it could be possible to build more than one RAID-6,
increasing the effective redundancy.

All with the performance price I mentioned at the
beginning.

bye,

-- 

piergiorgio
