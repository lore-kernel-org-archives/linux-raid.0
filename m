From: Steve Bergman <sbergman27@gmail.com>
Subject: Is this expected RAID10 performance?
Date: Thu, 6 Jun 2013 18:52:03 -0500
Message-ID: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a Dell T310 server set up with 4 Seagate ST2000NM0011 2TB
drives connected to the 4 onboard SATA (3Gbit/s) ports of the
motherboard. Each drive is capable of doing sequential writes at
151MB/s and sequential reads at 204MB/s according to bonnie++. I've
done an installation of Scientific Linux 6.4 (RHEL 6.4) and let the
installer set up the RAID10 and logical volumes. What I got was a
RAID10 device with a 512K chunk size, and ext4 extended options of
stride=128 & stripe-width=256, with a filesystem block size of 4k. All
of this seems correct to me.

But when I run bonnie++ on the array (with ext4 mounted
data=writeback,nobarrier)  I get a sequential write speed of only
160MB/s, and a sequential read speed of only 267MB/s. I've verified
that the drives' write caches are enabled.

"sar -d" shows all 4 drives in operation, writing 80MB/s during the
sequential write phase, which agrees with the 160MB/s I'm seeing for
the whole array. (I haven't monitored the read test with sar.)

Is this about what I should expect? I would have expected both read
and write speeds to be higher. As it stands, writes are barely any
faster than for a single drive. And reads are only ~30% faster.

Thanks for any info,
Steve Bergman
