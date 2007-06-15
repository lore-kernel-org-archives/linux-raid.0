From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: XFS Tunables for High Speed Linux SW RAID5 Systems?
Date: Fri, 15 Jun 2007 16:36:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706151634130.26033@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was wondering if the XFS folks can recommend any optimizations for high 
speed disk arrays using RAID5?

As well as if there is anything else I can do on the MD side?

fs.xfs.restrict_chown = 1
fs.xfs.irix_sgid_inherit = 0
fs.xfs.irix_symlink_mode = 0
fs.xfs.panic_mask = 0
fs.xfs.error_level = 3
fs.xfs.xfssyncd_centisecs = 3000
fs.xfs.inherit_sync = 1
fs.xfs.inherit_nodump = 1
fs.xfs.inherit_noatime = 1
fs.xfs.xfsbufd_centisecs = 100
fs.xfs.age_buffer_centisecs = 1500
fs.xfs.inherit_nosymlinks = 0
fs.xfs.rotorstep = 1
fs.xfs.inherit_nodefrag = 1
fs.xfs.stats_clear = 0

There is also vm/dirty tunable in /proc.

I was wondering what are some things to tune for speed?  I've already 
tuned the MD layer but is there anything with XFS I can also tune?

echo "Setting read-ahead to 64MB for /dev/md3"
blockdev --setra 65536 /dev/md3

echo "Setting stripe_cache_size to 16MB for /dev/md3"
echo 16384 > /sys/block/md3/md/stripe_cache_size

(also set max_sectors_kb) to 128K (chunk size) and disable NCQ

Justin.

