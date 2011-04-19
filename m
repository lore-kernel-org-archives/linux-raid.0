From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/4] Report new_disks number when migration is started
Date: Tue, 19 Apr 2011 08:39:07 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D1924108B0@irsmsx503.ger.corp.intel.com>
References: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
	<20110418103351.76f3f594@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D192410313@irsmsx503.ger.corp.intel.com>
 <20110419172750.51b27006@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110419172750.51b27006@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, April 19, 2011 9:28 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 0/4] Report new_disks number when migration is
> started
> 
> On Mon, 18 Apr 2011 11:52:12 +0100 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Monday, April 18, 2011 2:34 AM
> > > To: Kwolek, Adam
> > > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > > Neubauer, Wojciech
> > > Subject: Re: [PATCH 0/4] Report new_disks number when migration is
> > > started
> > >
> > > On Fri, 15 Apr 2011 14:30:22 +0200 Adam Kwolek
> <adam.kwolek@intel.com>
> > > wrote:
> > >
> > > > External metadata handler reports starting disks number during
> > > expansion
> > > > until migration is finished. It is opposite to native metadata
> > > behavior
> > > > where new disks number is reported immediately when expansion is
> > > started.
> > > > This causes problem during expansion restart and causes exception
> > > > due to wrong disks number information.
> > > >
> > > > This patch series unifies reported raid disks number. After
> reshape
> > > > is started external metadata handler reports new disks number now.
> > > >
> > > > BR
> > > > Adam
> > > >
> > > > ---
> > > >
> > > > Adam Kwolek (4):
> > > >       FIX: Count correctly added devices
> > > >       FIX: Set proper raid disks during migration
> > > >       FIX: Fiddle raid_disks number for external metadta
> > > >       FIX: Always report new raid_disks during migration
> > > >
> > > >
> > >
> > > Thanks.  I've applied all this.
> > >
> > > I change the second one a bit - please check that it still works for
> > > you.
> >
> > Unfortunately it doesn't work.
> > During restart 3-disks raid5 to 5-disks expansion  it stops in
> reshape_array() on first condition after change (Grow.c:1695)
> > 	reshape.before.raid_disks +reshape.parity != info-
> >array.raid_disks
> > where:
> > 	reshape.before.raid_disks = 2
> > 	reshape.parity = 1
> > 	info->array.raid_disks = 5
> >
> > It is used during restart only (checked for restart flag).
> >
> > Do not you think that in this condition instead
> reshape.before.raid_disks, reshape.after.raid_disks should be used?
> > For both (native and external) metadata formats during reshape restart
> new raid_disks will be reported so 'after' filed should be used.
> > Patch for this will follow this post.
> >
> > BR
> > Adam
> >
> 
> Thanks for testing and for the patch.
> 
> However I think I do want to still test before.raid_disk... though it is
> all
> a bit messy.
> 
> Anyway I've commited the patch like this...


Thanks, it's ok :)

BR
Adam


> 
> Thanks.
> NeilBrown
> 
> From 384e9be1330c29b40559f85dd0e6124bd0dfa535 Mon Sep 17 00:00:00 2001
> From: Adam Kwolek <adam.kwolek@intel.com>
> Date: Tue, 19 Apr 2011 17:25:43 +1000
> Subject: [PATCH] FIX: Check correctly raid disks during reshape restart
> 
> During reshape restart info->array.raid_disks contains new raid_disks
> number
> It cannot be compared against old disks number. Such check will always
> fail.
> 
> Check raid disks array field against final disks number for restart.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  Grow.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 9c1f096..9c63036 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1692,7 +1692,8 @@ static int reshape_array(char *container, int fd,
> char *devname,
>  	if (restart &&
>  	    (reshape.level != info->array.level ||
>  	     reshape.before.layout != info->array.layout ||
> -	     reshape.before.data_disks + reshape.parity != info-
> >array.raid_disks)) {
> +	     reshape.before.data_disks + reshape.parity
> +	     != info->array.raid_disks - info->delta_disks)) {
>  		fprintf(stderr, Name ": reshape info is not in native format
> -"
>  			" cannot continue.\n");
>  		goto release;
> --
> 1.7.3.4
> 
> 

