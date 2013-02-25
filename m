From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Backport Linux 3.7 MD RAID TRIM to Centos 6.3
Date: Mon, 25 Feb 2013 17:42:48 -0500
Message-ID: <CAKHEz2b3LyJMXLuW8vNsx8itEtbKEaWjNFn8GHud91wObYRwFQ@mail.gmail.com>
References: <CAKHEz2ZUTqwhCgwkPM_1WSnU1PH=63pFss8WLJre9TixFGtv6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2ZUTqwhCgwkPM_1WSnU1PH=63pFss8WLJre9TixFGtv6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 12, 2012 at 11:42 PM, Dave Cundiff <syshackmin@gmail.com> wrote:
> I've been WAITING for TRIM to be added to the MD driver. Now that its in 3.7
> I just can't wait for it filter down to the distros.
>
> The patches submitted to 3.7 mostly apply to the RHEL/CentOS 6.3 kernel
> source. Because RHEL pulls in random stuff from newer kernels its hard to
> tell what other patching is needed. Before I go digging attempting to finish
> applying and working out issues I was wondering if anyone more familiar
> would know if there were other kernel patches that the TRIM patches depend
> upon.
>

So I'm almost done with the backport. RedHat will probably be
releasing it in one of their updates any second now but hey it was
still fun.

Linear/Raid0/Raid1 is working fine
Raid5 I haven't touched

Raid10 seems to be having an alignment issue thats disabling discard.
This may be present in the mainline as well or I'm just missing some
other kernel change between the two.

The following is what set on my devices

md2 : active raid10 sda3[5] sdf3[4] sde3[3] sdd3[2] sdc3[1] sdb3[0]
      655491072 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU]

physical devices:
discard_max_bytes: 2199023255040
discard_granularity: 33553920
discard_alignment: 0
Phys/Log block size: 512

MD device:
discard_max_bytes: 524288 (equal to chunk size)
discard_granularity: 33553920 (same as physical)
discard_alignment: 26769408
Phys/Log block size: 512

It appears I've missed something somewhere that should be bringing the
granularity and the alignment of the md device down to more closely
match its chunk size. When any size discard goes through
blkdev_issue_discard the following code sets max_discard_sectors to 0
and disables the feature.

/* Zero-sector (unknown) and one-sector granularities are the same.  */
  granularity = max(q->limits.discard_granularity >> 9, 1U);
  alignment = bdev_discard_alignment(bdev) >> 9;
  alignment = sector_div(alignment, granularity);
  printk("granularity: %d Alignment: %d\n", granularity, alignment);
  /*
   * Ensure that max_discard_sectors is of the proper
   * granularity, so that requests stay aligned after a split.
   */
  max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
  printk("max_discard_sectors: %d\n", max_discard_sectors);
  sector_div(max_discard_sectors, granularity);
  max_discard_sectors *= granularity;

  printk("max_discard_sectors: %d\n", max_discard_sectors);

if (unlikely(!max_discard_sectors)) {
    /* Avoid infinite loop below. Being cautious never hurts. */
    return -EOPNOTSUPP;
  }

The values I get for the printks are as follows
granularity: 65535 Alignment: 54332
max_discard_sectors: 1024
max_discard_sectors: 0

Any pointers would be appreciated. Mainly I'm trying to figure out how
the md block device sets its granularity and alignment.

--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
