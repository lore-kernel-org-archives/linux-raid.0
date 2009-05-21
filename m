From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Thu, 21 May 2009 21:48:36 +1000
Message-ID: <18965.16276.485692.812516@notabene.brown>
References: <1241300764.5607.36.camel@raz>
	<e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: raz ben yehuda <raziebe@013.net>, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Tuesday May 19, dan.j.williams@intel.com wrote:
> On Sat, May 2, 2009 at 2:46 PM, raz ben yehuda <raziebe@013.net> wrote:
> > Neil Hello
> > The bellow is the raid0 grow code.I have decided to fix raid0 and not
> > perform the transformation raid0-raid4-raid0 due to two reasons:
> > 1. raid0 zones. this patch support any zone transformations.
> > 2. Undesired dependency of raid0 over raid4 re-striping code.
> 
> Hi Raz,
> 
> Can you explain a bit more about why the raid4 approach is
> undesirable?  I think making reshape only available to raid0 arrays
> where all the members are the same size is a reasonable constraint.
> We then get the nice benefit of reusing the raid5 reshape
> infrastructure.  In other words I am not convinced that the benefits
> of reimplementing reshape in raid0 outweigh the costs.

I've been thinking about this too... Is it something we really want to
do?

My thoughts include:

 - I don't like special cases - it would be nice to support reshape on
   all arrays, even RAID0 with different sizes devices.
 - Anyone who does this with a raid0 made of simple drives is asking
   for trouble.  But a RAID0 over a bunch of RAID5 or RAID1 might make
   sense. 
 - Maybe we should support different sized drives in RAID4.  As long
   as the parity drive is as big as the largest data drive it could be
   made to work.  Similarly hot spares would need to be big, but you
   could have 2 hot spares and take the smallest one that is big
   enough.
   If a drive in the RAID4+ (or is it is the thing called NORAID?)
   failed and was replaced with a bigger drive, it would be cool to be
   able to incorporate that extra space into the array.

   If we did all that, then the 0->4->0 conversion could make use of
   the same code.
 - Surely RAID0 is (like LVM) just a legacy idea until we get sensible
   file systems that actually understand multiple devices and do all
   this stuff for you are a more sensible level - so why are we
   busting a gut(*) to make RAID0 work well??  Answer is of course
   that no-one has made a sensible file system yet. (well... maybe zfs
   or btrfs, not sure)
 - If you read the DDF spec carefully, you find there is a secondary
   raid level which stripes over heterogeneous arrays a different way.
   You divide every primary array up into N chunks, so the chunk sizes are
   different on different arrays.  Then you make a secondary array by
   striping over those chunks.
   So e.g. you might have a 4Gig RAID5 and a 1GIG RAID1.  So the
   stripes array on top of these could take 4Meg from the RAID5, then
   1Meg from the RAID1, then another 4 from the RAID5 etc.
   So we want to support that?  And would we want to reshape such a
   thing??

So: lots of thoughts, some pointing in different directions.
But I'm not against reshape code appearing in RAID0 providing it is
well designed, maintainable, reliable, and doesn't slow down normal
RAID0 processing.  I suspect we can get there.

NeilBrown




* is that an Australian term??? not sure.  http://www.wordwebonline.com/en/BUSTAGUT
