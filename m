From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [AUTOREBUILD 0/8] Autorebuild monitor patches based on user
 defined policy
Date: Wed, 20 Oct 2010 16:41:15 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D174710277@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D171D09950@irsmsx503.ger.corp.intel.com>
 <20101019114027.37d65a8c@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101019114027.37d65a8c@notabene>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> 
> On Fri, 1 Oct 2010 13:36:48 +0100
> "Labun, Marcin" <Marcin.Labun@intel.com> wrote:
> 
> > >From f423b226f10cfe3b416c5e0580dde45cd8ca887d Mon Sep 17 00:00:00
> 2001
> > From: Marcin Labun <marcin.labun@intel.com>
> > Date: Wed, 29 Sep 2010 06:12:38 +0200
> > Subject: [AUTOREBUILD 0/8] Autorebuild monitor patches based on user
> defined policy
> >
> > This is updated series of patches forming autorebuild functionality
> in mdadm
> > monitor based on new policy code.
> 
> Hi Marcin,
>  thanks for this, and apologies for not replying sooner.
>  I've had a bit of a look and some of it seems good.
>  I haven't had a thorough look yet as I am in the middle of doing some fairly
>  serious refactoring of mdadm (the supertype, and mdinfo structures are going
>  to be heavily changed and largely merged - some super_switch methods> will
>  disappear (e.g. getinfo_super) and others will appear (load_container)).
>  Once I have finished that I will review your code more thoroughly and merge
>  it into the new code base.
> 
>  One concern I do have is patch 0002 which removes the spare-group based
>  spare migration.  That functionality needs to stay, though obviously the
>  implementation can change.  I imagine the 'spare-group' information would be
>  added to each member device as a 'domain' name.
> 
>  Also it is best not to remove functionality and then re-add it a different
>  way, but rather to make sure the functionality works after every change, but
>  just gets extended at various points.
> 
Hi Neil,
Next week we are planning to make another drop that includes spare-groups and a number of code rework changes.
Thanks,
Marcin

