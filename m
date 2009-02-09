From: "Thomas J. Baker" <tjb@unh.edu>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks  
 reporting "No md superblock detected"?
Date: Mon, 09 Feb 2009 09:48:18 -0500
Message-ID: <1234190898.10428.7.camel@localhost.localdomain>
References: <1233775657.10151.5.camel@localhost.localdomain>
	 <18827.51024.270348.20624@notabene.brown>
	 <1233952325.9786.20.camel@localhost.localdomain>
	 <5b35884ec706518d378265e6b95ace53.squirrel@neil.brown.name>
	 <1233956838.9786.37.camel@localhost.localdomain>
	 <a12770d97b01cc418aaff84bdd9e9349.squirrel@neil.brown.name>
Reply-To: tjb@unh.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a12770d97b01cc418aaff84bdd9e9349.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2009-02-07 at 13:09 +1100, NeilBrown wrote:
> On Sat, February 7, 2009 8:47 am, Thomas J. Baker wrote:
> > On Sat, 2009-02-07 at 08:01 +1100, NeilBrown wrote:
> >> On Sat, February 7, 2009 7:32 am, Thomas J. Baker wrote:
> >>
> >> > Thanks for the info. I think I follow everything. One last question
> >> > before really trying it - is this what is expected when I actually run
> >> > the command - the warnings about previous array, etc?
> >>
> >> Yes, you would expect exactly those messages.
> >>
> >> NeilBrown
> >>
> >
> > OK, first I put the drives back to their original configuration (I had
> > swapped two banks to make them appear physically as the kernel sees them
> > logically to make it easier to track down the possibly faulty disks.)
> > For clarity, I put them back to the original configuration before trying
> > anything.
> >
> > Next I ran
> >
> > mdadm --create /dev/md0 --verbose --level=6 --raid-devices=26  \
> > /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 missing \
> > /dev/sdi1 missing /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 \
> > /dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sdt1 /dev/sdu1 /dev/sdv1 \
> > /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1
> 
> 
> You said  "--raid-devices=26".  Why did you do that?
> It should be '27'.
> You need to have 25 real devices and 2 'missing' devices.
> 24 of those real devices you can identify the correct position for
> by looking at the --examine information from before you tried to
> recreate the array.
> The 25th real device you have to guess which is likely to be
> the right one.
> 
> 
> >
> > which completed but when I fsck'd the disk, it wasn't happy, complaining
> > about a missing superblock on /dev/md0. I then stopped the array. I'm
> > not sure what to do next. It seems like the examine information of all
> > the disks has been updated by the last create. I guess I should only go
> > by the previous examine? As for the missing statement, should that only
> > relate to drives with no md superblock?
> 
> Yes, go by the previous examine information.
> 
> The 'missing' can be any two devices.  The important thing is the devices
> that aren't 'missing'.  They need to be devices that you have reason to
> believe belong to that slot in the array.
> 
> NeilBrown
> 

OK, specifying 27 devices worked and I successfully mounted the RAID and
looked around. Thanks again for the guidance! I guess things look OK
(there are directories and files!) 

I was wondering if I should fsck it before adding the other two disks
back in or after? Any other words of experience?

Thanks again,

tjb
-- 
=======================================================================
| Thomas Baker                                  email: tjb@unh.edu    |
| Systems Programmer                                                  |
| Research Computing Center                     voice: (603) 862-4490 |
| University of New Hampshire                     fax: (603) 862-1761 |
| 332 Morse Hall                                                      |
| Durham, NH 03824 USA              http://wintermute.sr.unh.edu/~tjb |
=======================================================================

