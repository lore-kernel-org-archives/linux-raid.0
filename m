From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 13 May 2009 07:44:29 +1200
Message-ID: <1242157469.18958.13.camel@ezra>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
	 <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
	 <1241406283.17240.26.camel@ezra> <87fxff462s.fsf@frosties.localdomain>
	 <21cdc7a16fbdd42979d52331db97c737.squirrel@neil.brown.name>
	 <87ws8r2pqf.fsf@frosties.localdomain>
	 <18953.2936.212863.158003@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18953.2936.212863.158003@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2009-05-12 at 15:39 +1000, Neil Brown wrote:
> On Saturday May 9, goswin-v-b@web.de wrote:
> > "NeilBrown" <neilb@suse.de> writes:
> > 
> > > On Sat, May 9, 2009 7:50 am, Goswin von Brederlow wrote:
> > >
> > >>>> So I still plan to offer a "--reserve-space=2M" option for mdadm to
> > >>>> allow the first 2M of each device to not used for raid data.  Whether
> > >>>> any particular usage of this option is viable or not, is a different
> > >>>> question altogether.
> > >>
> > >> How exactly would that layout be then?
> > >>
> > >> Block  0   bootblock
> > >> Block  1   raid metadata
> > >> Block  x   2M reserved space
> > >> Block x+2M start of raid data
> > >>
> > >> Like this?
> > >
> > > When using 1.2 metadata, yes, possible with bitmap
> > > inserted  between the reserved space and the start of raid data.
> > 
> > That realy seems to be the best option. Simple to implement, simple to
> > use and if mdadm copies the reserved space from old to new drives when
> > adding one it gives us exactly what we want.
> > 
> > Are you working on that already or do you think it needs more discussion?
> 
> Discussion is good....
> 
> I have just pushed out some changes to the 'master' branch of
>    git://neil.brown.name/mdadm
> 
> The last patch adds "--reserve-space=" support to create.
> It only works with 1.x metadata (and causes the default to be 1.0).
> 
> You cannot hot-add a bitmap to a 1.1 or 1.2 array created with this
> feature (the kernel cannot be told the right thing to do yet).
> 
> The space can have a K, M, or G suffix with the obvious meanings.
> K is the default.
> 
> mdadm currently does not copy any data from one device to another.
> This could possibly be added for "--add" but not for "--create".

Could we do this better using containers and snia's ddf in intels matrix
(or our own) metadata to define the data areas and this way create a
raid1 container at the start of the disks and use 1.0 format superblock
and metadata at the end of the drive (as long as this doesn't mess with
the metadata.  

This would solve the syncing of boot sectors because it would be done as
part of normal raid 1.  Hot add would simply be a matter of adding
members to the container.  The only issue I can see is whether you are
able to hot resize the data areas in containers as part of the grow
feature, or would we have to do a metadata tweak to redefine the size of
data areas.

-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

