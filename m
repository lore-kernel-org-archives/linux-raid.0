From: pg_xfs2@xfs2.sabi.co.UK (Peter Grandi)
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors Again
Date: Tue, 19 Feb 2008 21:48:34 +0000
Message-ID: <18363.20146.915847.330349@tree.ty.sabi.co.UK>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
	<29a863790801161009h7bb1f0f7v34bc893fce338567@mail.gmail.com>
	<alpine.DEB.0.999999.0801161316280.1151@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801161316280.1151@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <linux-xfs@oss.sgi.com>
List-Id: linux-raid.ids

>> What sort of tools are you using to get these benchmarks, and can I
>> used them for ext3?

The only simple tools that I found that gives semi-reasonable
numbers avoiding most of the many pitfalls of storage speed
testing (almost all storage benchmarks I see are largely
meaningless) are recent versions of GNU 'dd' when used with the
'fdatsync' and 'direct' flags and Bonnie 1.4 with the options
'-u -y -o_direct', both used with a moderately large volume of
data (dependent on the size of the host adapter cache if any).

In particular one must be very careful when using older versions
of 'dd' or Bonnie, or using bonnie++, iozone (unless with -U or
-I), ...

[ ... ]

 > for i in 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536
 > do
 > cd /
 > umount /r1
 > mdadm -S /dev/md3
 > mdadm --create --assume-clean --verbose /dev/md3 --level=5 --raid-devices=10 --chunk=$i --run /dev/sd[c-l]1
 > /etc/init.d/oraid.sh # to optimize my raid stuff
 > mkfs.xfs -f /dev/md3
 > mount /dev/md3 /r1 -o logbufs=8,logbsize=262144
 > /usr/bin/time -f %E -o ~/$i=chunk.txt bash -c 'dd if=/dev/zero of=/r1/bigfile bs=1M count=10240; sync'
 > done

I would not consider the results from this as particularly
meaningful (that 'sync' only helps a little bit) even for
large sequential write testing. One would have also to document
the elevator used and the flushed daemon parameters.

Let's say that storage benchmarking is a lot more difficult and
subtle than it looks like to the untrained eye.

It is just so much easier to use Bonnie 1.4 (with the flags
mentioned above) as a first (and often last) approximation (but
always remember to mention which elevator was in use).
