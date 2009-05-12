From: Neil Brown <neilb@suse.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 12 May 2009 15:39:04 +1000
Message-ID: <18953.2936.212863.158003@notabene.brown>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
	<e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
	<1241406283.17240.26.camel@ezra>
	<87fxff462s.fsf@frosties.localdomain>
	<21cdc7a16fbdd42979d52331db97c737.squirrel@neil.brown.name>
	<87ws8r2pqf.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Saturday May 9
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday May 9, goswin-v-b@web.de wrote:
> "NeilBrown" <neilb@suse.de> writes:
> 
> > On Sat, May 9, 2009 7:50 am, Goswin von Brederlow wrote:
> >
> >>>> So I still plan to offer a "--reserve-space=2M" option for mdadm to
> >>>> allow the first 2M of each device to not used for raid data.  Whether
> >>>> any particular usage of this option is viable or not, is a different
> >>>> question altogether.
> >>
> >> How exactly would that layout be then?
> >>
> >> Block  0   bootblock
> >> Block  1   raid metadata
> >> Block  x   2M reserved space
> >> Block x+2M start of raid data
> >>
> >> Like this?
> >
> > When using 1.2 metadata, yes, possible with bitmap
> > inserted  between the reserved space and the start of raid data.
> 
> That realy seems to be the best option. Simple to implement, simple to
> use and if mdadm copies the reserved space from old to new drives when
> adding one it gives us exactly what we want.
> 
> Are you working on that already or do you think it needs more discussion?

Discussion is good....

I have just pushed out some changes to the 'master' branch of
   git://neil.brown.name/mdadm

The last patch adds "--reserve-space=" support to create.
It only works with 1.x metadata (and causes the default to be 1.0).

You cannot hot-add a bitmap to a 1.1 or 1.2 array created with this
feature (the kernel cannot be told the right thing to do yet).

The space can have a K, M, or G suffix with the obvious meanings.
K is the default.

mdadm currently does not copy any data from one device to another.
This could possibly be added for "--add" but not for "--create".

Any reports of success or failure, or other comments would be most
welcome.


> 
> > When using 1.0, it would be
> >
> >   Block 0..N-1   boot block and second stage
> >   Block N..near-the-end raid data
> >   Block x..y     bitmap
> >   block z        superblock
> 
> I never liked the idea of 1.0.
> 
> What actualy does happen when you have raid on partitions and resize a
> partition? Am I right that the raid then can't be assembled until the
> raid itself gets grown (and the superblock gets moved to the new end)?


If you resize the partition under a 0.90 or 1.0 array, then md will
lose track of the metadata and you wont be able to assemble the array
again (there is nothing that will move it to the end).

How often do you resize a partition when there is data on it?  I
suspect only when the partition is a logical volume.  In that case 1.0
is awkward.  In others it works fine.

NeilBrown
