From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Wed, 19 May 2004 23:27:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405200327.i4K3R5B17826@www.watkins-home.com>
References: <1085018769.2042.32.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1085018769.2042.32.camel@localhost>
To: office@ninti.com.au, 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

As I understand it, RAID1 does not have a chunk size, or a strip size.
So stride should not apply.

No need to have that keyword in the config file.

RAID0 does have a chunk size.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ninti Systems
Sent: Wednesday, May 19, 2004 10:06 PM
To: 'LinuxRaid'
Subject: RE: Please review: Slackware RAID How-To

But is the stride parameter required at all if I'm only building a RAID1
array with two disks?

Also, is the chunk size necessary in this case as I remember getting a
message on boot up to the effect that "Chunk size not necessary here,
but proceeding anyway!".

Thanks

Mick


On Thu, 2004-05-20 at 11:12, John Lange wrote:
> On Sun, 2004-05-16 at 23:51, Guy wrote:
> > md2 has 4 disks with a chunk size of 128K.  Since only 3 disks are used
for
> > data, and the filesystem block size is 4K, the stride size should be
> > 128*3/4, or 96.
> > Change:
> > 	mke2fs -b 4096 -R stride=32 /dev/md2
> > To:
> > 	mke2fs -b 4096 -R stride=96 /dev/md2
> > 
> > My logic:
> > 	"Stripe size" is "chunk size" times "number of data disks".
> > 	From example:
> > 		"chunk size" = 128
> > 		"number of data disks" = "nr-raid-disks" - 1 (-2 if RAID6)
> 
> I think this is incorrect. At this point I defer to the
> Software-RAID-HOWTO.
> 
> http://www.tldp.org/HOWTO/Software-RAID-HOWTO-5.html#ss5.10
> 
> >From that document stride is chucksize/blocksize . Number of disks does
> not enter into it.
> 
> So with a chunksize of 128, and a block size of 4 it would be:
> 
> 128K/4K = 32 for stride.
> 
> If this is indeed correct I will be sure to expand that area of the
> How-To so it is more clear.
> 
> Thanks very much for your feedback.
> 
> Regards,
> 
> John Lange
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
--------------------------------------
Ninti Systems: Smart IT Solutions
Michael Hall
Mobile: 0429 095 392
Ph/Fax: 08 8953 1442       
Email:  office at ninti dot com dot au
Web:    http://ninti.com.au
--------------------------------------

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


