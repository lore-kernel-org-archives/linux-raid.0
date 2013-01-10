From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Thu, 10 Jan 2013 03:49:46 -0700
Message-ID: <201301100349.46794.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301091141.52238.thomas@fjellstrom.ca> <4A81E770-60DD-4C5F-A341-B449BF2C381F@colorremedies.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A81E770-60DD-4C5F-A341-B449BF2C381F@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed Jan 9, 2013, you wrote:
> On Jan 9, 2013, at 11:41 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> > So I've retested the array without bcache in th way, and my write speeds
> > are still a fraction of the read speeds. Is this normal for a setup like
> > mine?
> 
> It looks like roughly 1/3 of the write performance? There is a
> non-insignificant penalty with RAID6 writes in IOPS, so I would look at
> whether your test is even valid; i.e. is it writing or rewriting in
> amounts that match what you will be using the array for? If not,
> disqualify the test and results and come up with something else that's
> more like the actual usage.

A lot of it will be streaming. Some may end up being random read/writes. The 
test is just to gauge over all performance of the setup. 600MBs read is far 
more than I need, but having writes at 1/3 that seems odd to me.

> Is this for DAS? For big media files, IOPS is not typically what you need.
> You get large sequential writes.

IOPS is not something I'm worrying about, but 1/3 the write throughput seems a 
bit off to me. I assume I've mis-configured something.

> > IBM M1015 flashed with the LSI 9211-8i IT firmware
> > 7x2TB Seagate Baracuda HDDs in raid6 unpartitioned and formatted with XFS
> 
> I'm not following. This is a SAS controller and you're using a Barracuda,
> which I think is a SATA drive? If you're using SAS drives, I'd expect them
> to be good enough quality and low UER that you could do RAID5 and avoid
> some of the write penalty. RAID 6 implies quite a few drives, have you
> considered RAID 10 instead? That card will do RAID 10 itself. The other
> possibility just RAID 0 the thing for DAS, and then back it up daily with
> rsync to a separate DAS RAID 0, or linear array.

Its a relatively inexpensive ($80-100) 8 port SAS/SATA controller. And I have 
it flashed in IT mode, so theres no RAID support what so ever. I'm not a big 
fan of hardware based raid, as it tends to be rather proprietary and you end 
up having just one more weak link in the chain to account for (you get to buy 
identical backup cards to make sure you have spares, since no other cards will 
likely like any meta data, or on disk layout the original happened to use).

This is primarily a media and file share. RAID 10 comes with a rather large 
space penalty (50%) which is not something I want to deal with. I'd end up 
with an array the same size as my current 7x1TB RAID5, which is full. My idea 
was to make a 10TB array to replace the current one, and recommission some of 
those disks for use in a backup array (with some 3TB drives I picked up)

The reason I've selected RAID6 to begin with is I've read (on this mailing 
list, and on some hardware tech sites) that even with SAS drives, the 
rebuild/resync time on a large array using large disks (2TB+) is long enough 
that it gives more than enough time for another disk to hit a random read 
error, which will kick the disk out of the array, potentially giving you a 
double fault and taking the entire array out. This is something I'd like to 
avoid. But something I also don't want to spend 2x the money on drives for. 
Also going with parity based RAID so the array isn't totally out of commission 
for long stretches, even then theres some kind of error taking out one of the 
disks (and resync times are short due to using mdraid's write intent bitmap).


> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
