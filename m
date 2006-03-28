From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Conflicting Size Numbers -- Bug in mdadm, md, df?
Date: Tue, 28 Mar 2006 20:36:56 +0300
Message-ID: <5b170a7d0603280936j4adb9170x3081e1680f12d963@mail.gmail.com>
References: <4428228E.8080909@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4428228E.8080909@aol.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 3/27/06, andy liebman <andyliebman@aol.com> wrote:
> Case 1: When we stripe together TWO RAW 3ware RAID-5 devices (i.e.,
> /dev/sdc + /dev/sdd = /dev/md2), "df -h" tells us that the device is 11
> TB in size. "df -k" tells us that the device is 10741827072 blocks in
> size and "cat /proc/partitions" tells us the md device is 10741958144
> blocks in size (a little larger)

This is what you lose in creating a file system. df reports available
space usable in files, /proc/partitions reports the underlying block
device.

> Case 2: When we create a SINGLE partition on each 3ware device using
> parted, the partitions /dev/sdb1 and /dev/sdc1 are each reported to be
> 34 blocks smaller than the RAW 3ware devices mentioned above in Case 1.

Partition table+overhead

> Yet, when we stripe together /dev/sdb1 + /dev/sdc1, we get a Linux md
> device that is IDENTICAL in size to the "Linux md" device mentioned
> above -- 10741958144 blocks. We don't understand why the resulting
> "Linux md" device isn't 68 blocks smaller than when we use the raw 3ware
> device. In the SINGLE partition case, "df -h" also tells us that the
> device is 11 TB in size.

I'd suspect the reason is RAID with 256k chunk size. The resulting
block device is rounded down - and 68 blocks isn't that much. Didn't
do the math tho.

> Case 3: However, when we use mdadm to stripe together the first
> partition on each device and also to stripe together the second
> partition on each device (/dev/sdb1 + /dev/sdc1 = /dev/md1 AND /dev/sdb2
> + /dev/sdc2 = /dev/md2), "df -h reports that the total size of the two
> Linux RAID-0 arrays is 0.8 TB LESS than when we stripe together the RAW
> 3ware devices or when we only have ONE partition.

That seems curious, however I'd trust the block count in this case.
0.8TB is a lot.

> And "df -k" reports
> that the total block size of the two mdX arrays is 10741694464 blocks,
> which is 114532 blocks smaller than size reported for the "md" device
> when we have NO partitions and 132072 blocks smaller than when we have a
> SINGLE partition.

In addition to chunk size rounding, you also lose some space to md
superblock and other stuff (bitmap, etc if you have those). 100k
blocks is around what I'd expect. Didn't do the math here either, tho.

> We are wondering what these discrepencies mean and whether they could
> lead to filesystem corruption issues?

Hope i've shed some light on this.

mdadm 1.x isn't the latest. 2.3.x is.

Tuomas
