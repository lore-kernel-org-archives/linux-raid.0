From: Scott Mcdermott <smcdermott@questra.com>
Subject: Re: RAID1 problem, newbie to RAID
Date: Mon, 20 Jan 2003 20:03:45 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030121010345.GF10369@questra.com>
References: <3E2C8884.8040003@nan0.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E2C8884.8040003@nan0.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

J Dalessandro on Mon 20/01 16:38 -0700:
> I seem to get two out of three partitions. I think my problem is in
> that my "/" partition is mounted, but I'm new to RAID and I'm not sure
> how to fix this issue.

You can't have the filesystem mounted from the device you want to make
RAID; you have to boot from something else to do it before mounting it.

Also please realize that when you use persistent-superblock 1, mkraid
will use the last 4k (I think that's how much) for MD information,
overwriting filesystem data there, so you have to resize2fs if you have
existing data, before doing the mkraid.  If you didn't do this, your FS
is now hosed, but maybe you didn't have any data blocks there (after
all, 4k is usually only one filesystem block) and e2fsck will repair it
without data loss.  Using debugfs and dumpe2fs will tell you more
information.

Also, I'm curious why you have the failed disks in your raidtab.
