From: keld@keldix.com
Subject: Re: Is this expected RAID10 performance?
Date: Sat, 8 Jun 2013 20:23:49 +0200
Message-ID: <20130608182349.GA8119@www5.open-std.org>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 06, 2013 at 06:52:03PM -0500, Steve Bergman wrote:
> I have a Dell T310 server set up with 4 Seagate ST2000NM0011 2TB
> drives connected to the 4 onboard SATA (3Gbit/s) ports of the
> motherboard. Each drive is capable of doing sequential writes at
> 151MB/s and sequential reads at 204MB/s according to bonnie++. I've
> done an installation of Scientific Linux 6.4 (RHEL 6.4) and let the
> installer set up the RAID10 and logical volumes. What I got was a
> RAID10 device with a 512K chunk size, and ext4 extended options of
> stride=128 & stripe-width=256, with a filesystem block size of 4k. All
> of this seems correct to me.
> 
> But when I run bonnie++ on the array (with ext4 mounted
> data=writeback,nobarrier)  I get a sequential write speed of only
> 160MB/s, and a sequential read speed of only 267MB/s. I've verified
> that the drives' write caches are enabled.
> 
> "sar -d" shows all 4 drives in operation, writing 80MB/s during the
> sequential write phase, which agrees with the 160MB/s I'm seeing for
> the whole array. (I haven't monitored the read test with sar.)
> 
> Is this about what I should expect? I would have expected both read
> and write speeds to be higher. As it stands, writes are barely any
> faster than for a single drive. And reads are only ~30% faster.

We have a wiki page on performance at https://raid.wiki.kernel.org/index.php/Performance

From the examples mentioned there you should be able to get something like
300 MB/s sequential write and 700 MB/s sequential read. Raid1 and raid10,near could
slow down your sequential read considerable, while raid10,far and raid5 should
give you read speed in the 700 MB/s range. Have a look at the bonnie results reported for
a variation on chunk size etc.

best regards
keld
