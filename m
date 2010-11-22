From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: Autorebuild, new dynamic udev rules for hot-plugs
Date: Mon, 22 Nov 2010 23:50:04 +0000
Message-ID: <66C59AD0932712458090B447266D638C0109E6AE6C@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638C0109E0E1E7@irsmsx504.ger.corp.intel.com>
 <20101122160201.24ad85f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101122160201.24ad85f8@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

Hi,

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Monday, November 22, 2010 6:02 AM
> To: Hawrylewicz Czarnowski, Przemyslaw
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Williams, Dan J;
> Ciechanowski, Ed; Labun, Marcin; Czarnowska, Anna
> Subject: Re: Autorebuild, new dynamic udev rules for hot-plugs
> 
> On Fri, 19 Nov 2010 15:12:19 +0000
> "Hawrylewicz Czarnowski, Przemyslaw"
> <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> 
> > Hi,
> >
> > I would like to present another patch for our autorebuild tree (it should
> be applied on the top of Autorebuild series, as devel-3.2 is not stable
> yet). Dan Williams proposed to reduce overhead associated with passing each
> hot-plugged block device to mdadm, using just the devices described in
> policies via mdadm.conf file.
> > See patch below for details, comments are as always very welcome.
> 
> I am in general in favour of this approach.
> It has the benefit that it can very easily be not-used if there turn out to
> be problems with it.
> 
> Four comments.
> 
> 1/ I wouldn't write a file in /lib/udev/rules.d/
>   I think it should be written to "/dev/.udev/rules.d/"
>   which is referred to as the "temporary rules directory"
>   in the udev documentation.
I am not sure if it is what we are looking for. Temporary means they disappear after reboot. It is OK as cold-plug does not need support for bare disks (or maybe I am wrong?). But in such case, one who wants to use autorebuild should invoke mdadm --activate-domains for example in /etc/init.d/local.boot or somewhere else. Second idea here is to use ActivateDomain() when one starts monitor with autorebuild enabled. Which one? I would prefer to leave it as it was written initially (considering comment #4). Then, if one removes policies from config, invoking --activate-domains should reset/remove rules (but see #3)

> 
> 2/ I would be good to process the type=disk or type=part part of the
>    policy into the rules file as well.
OK

> 
> 3/ I'm not very comfortable with hard-coding the name of the
>    file to be created in the rules.d directory.  Maybe usage could be
>       --activate-domains=63-md-whatever
Good idea, but only if we store our rules in /dev/.udev/rules.d. Otherwise it would be difficult to maintain all generated rules and remove the old ones... I would leave default if not given by user, but one can pass any file name.

> 
> 4/ I don't think it is good to have an incomplete file in rules.d that udev
>    might accidentally read.  We should create the file with a name with a
>    leading '.' (assuming udev ignores those, I haven't checked) and then
>    rename it after it has been completely written.
You're right. In theory, such partial udev rules are excluded when udev can't interpret them properly. I have looked into udev's sources and found that it looks for "*.rules" files. All other file extensions are ignored. Files with leading dots are also omitted. I would prefer to create <name>.temp file and then rename it into <name>.rules.

> 
> Other than that, it looks pretty good.
Great

> 
> Thanks,
> NeilBrown
> 
> >
> > Date: Thu, 18 Nov 2010 01:19:52 +0100
> > Subject: [PATCH] New dynamic hot-plug udev rules for policies
> >
> > When introducing policies, new hot-plug rules were added to support
> > bare disks. Mdadm was started for each hot plugged block device
> > to determine if it could be used as spare or as a replacement member for
> > degraded array.
> > This patch introduces limitation of range of devices that are handled
> > by mdadm. It limits them to the ones specified in domains associated
> > with the actions: spare-same-port, spare and spare-force.
> > In order to enable hot-plug for bare disks one must update udev rules
> > with command
> >
> > 	mdadm --activate-domains
> >
> > After mdadm.conf is changed one is obliged to re-run
> > "mdadm --activate-domains" command in order to bring the system
> > configuration up to date.
> > All hot-plugged disks containing metadata are still handled by existing
> > rules.
> >
> > Note: this patch is just a proposition to minimize overhead of using
> mdadm for
> > each plugged block device. If accepted, it will be incorporated in
> > previous implementation of hot-plug for bare disks.
> >
> > Signed-off-by: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com>
> > ---
> >  Makefile           |    2 +
> >  ReadMe.c           |    1 +
> >  mdadm.c            |    4 ++
> >  mdadm.h            |    9 +++-
> >  policy.c           |  137
> ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  udev-md-raid.rules |    5 +-
> >  6 files changed, 154 insertions(+), 4 deletions(-)
> >
[cut]
