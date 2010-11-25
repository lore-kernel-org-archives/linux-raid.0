From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: Devel 3.2 branch issues
Date: Thu, 25 Nov 2010 10:28:15 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF92E9D@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03CC6@irsmsx504.ger.corp.intel.com>
	<20101123115213.3664ec27@notabene.brown>
 <20101125190152.01d61cbd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101125190152.01d61cbd@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Thursday, November 25, 2010 9:02 AM
> To: Czarnowska, Anna
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Williams, Dan J;
> Ciechanowski, Ed; Labun, Marcin; Hawrylewicz Czarnowski, Przemyslaw
> Subject: Re: Devel 3.2 branch issues
> 
> On Tue, 23 Nov 2010 11:52:13 +1100 Neil Brown <neilb@suse.de> wrote:
> 
> > On Mon, 22 Nov 2010 22:39:00 +0000
> > "Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:
> >
> > >
> > > > by the way, some of the changes in you of the patches you sent
> have not
> > > > been
> > > > included in any form.  They include:
> > > >
> > > > - the getinfo_super_disks method.  I couldn't see why you need
> this.
> > > > All the
> > > >   info about the state of the arrays should already be available.
> > > >   If there is something that you need that we don't have, please
> > > > explain and
> > > >   we can see how best to add it back in.
> > >
> > > Marcin has already answered this but here is my explanation.
> > > Current test devstate[i]==0 is always true for container so any
> device seems a good candidate to move.
> > > To be able to identify members, failed devices and real spares we
> updated devstate for containers.
> > > To find members we can just check which disks are used in
> subarrays, but a failed disk is removed from subarray after a short
> while and as soon as it happens we are not able to see a difference
> between the failed disk and a spare unless we look at metadata.
> >
> > Thanks.  That makes sense.  I'll look at the code and see about
> applying it.
> >
> 
> OK, I have something, though I haven't tested it.
> 
> It uses your getinfo_super_disks and does the following to choose a
> spare
> from an external array.  There are a couple of rearrangement patches
> before
> this so it won't apply as-it, but should appear in my devel-3.2 within
> a few
> hours.
> 
> NeilBrown
> 

Well, this didn't help. 
In the set of tests I have just posted even the basic ones fail for imsm.
For native there are still some problems with tests:
 5c - spare not moved to degraded array in the same domain. This is really basic test with 4 arrays instead of 2.
 9 - spare moved between different metadata arrays
13 - spare moved despite action=include which doesn't allow migration

Test9 run in scan mode generates a segmentation fault.

I will have a look at this in debugger and give you more info on the reasons later on.

Anna

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

