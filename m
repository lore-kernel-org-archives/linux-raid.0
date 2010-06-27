From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 write hole?
Date: Sun, 27 Jun 2010 22:16:13 +1000
Message-ID: <20100627221613.0c34c812@notabene.brown>
References: <20100626143125.GA1010@localhost>
	<4C27290D.6000609@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C27290D.6000609@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: Shaochun Wang <scwang@ios.ac.cn>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 27 Jun 2010 12:33:49 +0200
John Hendrikx <hjohn@xs4all.nl> wrote:

> Shaochun Wang wrote:
> > Hi:
> >
> > Recently I heard of the so called "write hole" problem of raid5 in
> > Linux software raid. I use ext4 filesystem on my NAS, which assembles
> > data disks using Linux software raid. So I wonder how safe my such
> > system!
> >
> > If the "write hole" is inevitable, will it result in the corruption of
> > ext4 filesystem? 
> The write hole occurs if your system crashes during a write operation, 
> where one stripe gets updated but the other corresponding stripe does 
> not.  This could lead to parity information not matching the 
> corresponding data.

Correct.

> 
> If the raid 5 system atleast ensures that the data stripe is always 
> written before parity, then the montly resync check that mdadm does 
> should be able to detect this and write new parity information.

This bit isn't so correct.
When the RAID5 is next assembled after the crash, if all devices are present
(i.e. the array is not degraded) then it will check and correct all the
parity blocks immediately.  If you have a write-intent-bitmap configured,
this will be quite quick.  If not it could take hours.

Once the resync has completed you are safe again, any risk from the "write
hole" will have disappeared.

If your array was degraded when the system crashed, or is degraded on
restart, or degrades before the resync completes, then you could suffer from
the "Write hole" ... if a write was interrupted by the crash.

In the first two cases (which are effectively the same case), mdadm will
refuse to assemble the array because it knows it could be suffering from a
write-hole problem.  You need to reassemble with "--force" which means you
acknowledge that there could be corruption due to the write hole.

If you lose a device during the resync you could still suffer from the write
hole, but md doesn't alert you to this.  That could be seen as a
short-coming, but I'm not sure how it might be fixed.  I wouldn't want the
array to suddenly stop working because there is suddenly a risk of write-hold
based corruption....

> 
> Atleast this way the bad parity does not lurk around forever on your 
> raid system causing numerous problems when a disk finally fails.

Yes, it certainly does not lurk forever - the resync fixes it.

> 
> The write hole is not inevitable, but would require some special 
> measures at the raid level which could affect performance.  And as with 
> any corruption, it could definitely corrupt your filesystem.

The write hole can be "fixed" in two ways that I am aware of.
1/ log all writes (including parity updates) to some stable storage before
   writing them to the RAID5.  This is typically done in "hardware RAID" cards
   using NVRAM for the stable storage.
   Once NVRAM is widely available on commodity server hardware I suspect
   md/raid5 will be enhanced to support this.  I have thought about doing
   this using a RAID1 as the alternate stable storage, but the performance
   cost is unlikely to acceptable.
2/ use a filesystem which understands the layout of the RAID5 and which
   somehow "knows" which stripes were written "recently" so that it can
   invalidate them (if it cannot verify them) after a crash.  This would
   almost certainly require a copy-on-write disciple in the filesystem.

NeilBrown
