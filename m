From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Thu, 20 May 2004 01:02:48 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405200502.i4K52rB18138@www.watkins-home.com>
References: <1085024014.6309.17.camel@ws101.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1085024014.6309.17.camel@ws101.darkcore.net>
To: 'John Lange' <john.lange@bighostbox.com>, office@ninti.com.au
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

More info!

I found this comment in another group.  It would indicate "stripe size"
should be used.  But it should not make a difference.

Guy

=======================================================================
The stride option places the inode and block bitmaps so that successive
block groups' bitmaps are on a different RAID stripes.  I suppose this
might improve disk I/O performance, as the bitmaps are the most heavily 
used blocks on the disk.  However, the cache should prevent most of the
I/O in the first place...

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of John Lange
Sent: Wednesday, May 19, 2004 11:34 PM
To: office@ninti.com.au
Cc: LinuxRaid
Subject: RE: Please review: Slackware RAID How-To

No, stride is not needed for RAID 1 as stride is about striping and RAID
1 does not do striping, it does mirroring.

According to man raidtab, chunk-size "Sets the stripe size to size
kilobytes.". So unless I'm completely off my rocker, chunk-size is also
not needed for RAID 1 as it also only applies to striping.

Thanks for pointing that out. I have removed it from my HowTo.

I believe this error is also in the Software RAID HowTo which is where I
copied my examples from.

Regards,

-- 
John Lange


On Wed, 2004-05-19 at 21:06, Ninti Systems wrote:
> But is the stride parameter required at all if I'm only building a RAID1
> array with two disks?
> 
> Also, is the chunk size necessary in this case as I remember getting a
> message on boot up to the effect that "Chunk size not necessary here,
> but proceeding anyway!".
> 
> Thanks
> 
> Mick
> 
> 
> On Thu, 2004-05-20 at 11:12, John Lange wrote:
> > On Sun, 2004-05-16 at 23:51, Guy wrote:
> > > md2 has 4 disks with a chunk size of 128K.  Since only 3 disks are
used for
> > > data, and the filesystem block size is 4K, the stride size should be
> > > 128*3/4, or 96.
> > > Change:
> > > 	mke2fs -b 4096 -R stride=32 /dev/md2
> > > To:
> > > 	mke2fs -b 4096 -R stride=96 /dev/md2
> > > 
> > > My logic:
> > > 	"Stripe size" is "chunk size" times "number of data disks".
> > > 	From example:
> > > 		"chunk size" = 128
> > > 		"number of data disks" = "nr-raid-disks" - 1 (-2 if RAID6)
> > 
> > I think this is incorrect. At this point I defer to the
> > Software-RAID-HOWTO.
> > 
> > http://www.tldp.org/HOWTO/Software-RAID-HOWTO-5.html#ss5.10
> > 
> > >From that document stride is chucksize/blocksize . Number of disks does
> > not enter into it.
> > 
> > So with a chunksize of 128, and a block size of 4 it would be:
> > 
> > 128K/4K = 32 for stride.
> > 
> > If this is indeed correct I will be sure to expand that area of the
> > How-To so it is more clear.
> > 
> > Thanks very much for your feedback.
> > 
> > Regards,
> > 
> > John Lange
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


