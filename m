From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [Patch 00/17] Autorebuild
Date: Thu, 18 Nov 2010 23:14:49 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
 <20101117212242.5ad7b210@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101117212242.5ad7b210@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,
I started testing new code today. Just the Incremental part.

There are few problems:
1. Cookie file is cleared before it is read so spare-same-slot can't work. It should be just open for reading. (probably a typo)
2. Container uuid instead of subarray uuid is written in cookie file, so for ddf it may not be clear which subarray used the slot.
3. Incremental fail does not work for external metadata. Przemek's original patch did fail the disk in subarrays. Now Manage_subdevs tries to fail a disk in container while subarray is expected. Do you intend to change Manage_subdevs to take a container?
4. With spare-same-slot when there is a cookie and disk has no metadata then we probably shouldn't look at domains. Just add.

This is all for now.
Regards
Anna


> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, November 17, 2010 11:23 AM
> To: Czarnowska, Anna
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Williams, Dan J;
> Ciechanowski, Ed; Labun, Marcin; Hawrylewicz Czarnowski, Przemyslaw
> Subject: Re: [Patch 00/17] Autorebuild
> 
> On Fri, 29 Oct 2010 15:13:40 +0100
> "Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:
> 
> > This is updated series of patches forming autorebuild functionality
> in mdadm monitor based on new policy code.
> 
> I Anna and all,
> 
> I have decided that the best way forward is for me to apply all of your
> patches and fix them up on the way.  It turned out there was quite a
> few
> changes that I wanted to make that I only discovered while examining
> the
> patches very closely, so this seems to be a very useful exercise.
> 
> I haven't finished yet, but you can see my current state - which is up
> to
> about patch 11 in your series - in my devel-3.2 branch.
> 
> Probably the most significant change so far is the interpretation of
> action=spare-same-slot.  I have defined that in a way that is *more*
> permissive than action=spare, where you had it less permissive.
> 
> The comment for that change set is below.
> The new list of policy actions is:
> 
> enum policy_action {
> 	act_default,
> 	act_include,
> 	act_re_add,
> 	act_spare,	/* This only applies to bare devices */
> 	act_spare_same_slot, /* this allows non-bare devices,
> 			      * but only if recent removal */
> 	act_force_spare, /* this allow non-bare devices in any case */
> 	act_err
> };
> 
> I'll hopefully get the rest of your patches done tomorrow and then I
> might
> start on Adam... and then on the changes that I want to make.
> If you can do some testing once enough code is in place, that would be
> great.
> Thanks,
> NeilBrown
> 
> commit a2191ce8af4aa178d62df759fab47ef4dc8e6f67
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Nov 17 12:46:35 2010 +1100
> 
>     Add action=spare-same-slot policy.
> 
>     When "mdadm -I" is given a device with no metadata, mdadm tries to
> add
>     it as a 'spare' somewhere based on policy.
> 
>     This patch changes the behaviour in two ways:
> 
>     1/ If the device is at a 'path' where a previous device was removed
>       from an array or container, then we preferentially add the spare
> to
>       that array or container.
> 
>     2/ Previously only 'bare' devices were considered for adding as
>       spares.  Now if action=spare-same-slot is active, we will add
>       non-bare devices, but *only* if the path was previously in use
>       for some array, and the device will only be added to that array.
> 
>     Based on code
>       From: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com>
> 
>     Signed-off-by: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
> 
> 
> >
> > Autorebuild Monitoring application:
> > Autorebuild monitor is part of monitor application (mdadm -F). In the
> current code of mdadm monitor autorebuild feature was based on spare
> group assignment in mdadm.conf file and worked only for native
> metadata. This code has been retained for compatibility with old config
> format.
> > The new autorebuild implementation works also for external metadata
> types. It uses the concept of domains in mdadm.conf introduced by Neil
> Brown.
> > Monitoring application periodically checks the state of MD active
> arrays and triggers a rebuild if there are eligible spare disks in
> other arrays/containers.
> > Degraded arrays are checked one by one. If there is a spare disk in
> other array/container that matches the domain of the degraded array and
> the domain action allows for spare sharing the spare is moved using
> existing Manage_subdevs function. If the addition fails, the spare
> device is moved back to the original container and next potential spare
> is tried. The process is repeated until all arrays are checked and the
> process is put into a sleep state for a configured period.
> >
> > New option --no-sharing has been added to Monitor mode to be able to
> run monitoring only (without moving spares). This is recommended when
> many instances of monitor are to be run on the same set of devices.
> > Spare sharing is allowed in only one instance of Monitor running with
> --scan option. User is still able to start Monitoring functions in
> multiple instances without --scan option.
> >
> > The autorebuild build-in assumptions are:
> > 1\spares are shared between the arrays of the same metadata 2\spares
> are moved only from containers/volumes that are not degraded 3\spares
> are moved to containers/volumes lacking a *good* spare (size)
> >
> > Anna Czarnowska
> > Przemyslaw Hawrylewicz-Czarnowski
> > Marcin Labun
> >
> > 0001-added-path-path_id-to-give-the-information-on-the-pa.patch
> > 0002-Update-of-udev-rules-to-support-IMSM-devices.patch
> > 0003-extension-of-IncrementalRemove-to-store-location-pat.patch
> > 0004-Incremental-for-bare-disks-implementation-of-spare-s.patch
> > 0005-Util-get-device-size-from-id.patch
> > 0006-Monitor-set-err-on-arrays-not-in-mdstat.patch
> > 0007-Monitor-spare-group-based-spare-sharing-moved-to-sep.patch
> > 0008-mdadm-added-no-sharing-option-for-Monitor-mode.patch
> > 0009-Monitor-avoid-skipping-checks-on-external-arays.patch
> > 0010-Monitor-include-containers-in-scan-mode.patch
> > 0011-Monitor-link-containers-with-subarrays-in-statelist.patch
> > 0012-imsm-create-mdinfo-list-of-disks-in-a-container-from.patch
> > 0013-Monitor-autorebuild-functionality-added.patch
> > 0014-Monitor-Respect-policy-in-auto-rebuild-in-mdadm-moni.patch
> > 0015-Monitor-more-accurate-size-check-when-looking-for-sp.patch
> > 0016-IMSM-Fix-problem-in-mdmon-monitor-of-using-removed-d.patch
> > 0017-Policy-is-aware-of-metadata-disk-s-controller-domain.patch
> >
> > Incremental.c      |  230 +++++++++++++++---
> > Makefile           |    3 +
> > Monitor.c          |  691
> ++++++++++++++++++++++++++++++++++++++++++++--------
> > ReadMe.c           |    4 +
> > managemon.c        |   38 +++
> > mdadm.c            |   29 ++-
> > mdadm.h            |   49 ++++-
> > policy.c           |  134 +++++++++-
> > super-intel.c      |  274 ++++++++++++++++++---
> > udev-md-raid.rules |    7 +-
> > util.c             |   23 ++
> > 11 files changed, 1290 insertions(+), 192 deletions(-)
> > ---------------------------------------------------------------------
> > Intel Technology Poland sp. z o.o.
> > z siedziba w Gdansku
> > ul. Slowackiego 173
> > 80-298 Gdansk
> >
> > Sad Rejonowy Gdansk Polnoc w Gdansku,
> > VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,
> > numer KRS 101882
> >
> > NIP 957-07-52-316
> > Kapital zakladowy 200.000 zl
> >
> > This e-mail and any attachments may contain confidential material for
> > the sole use of the intended recipient(s). Any review or distribution
> > by others is strictly prohibited. If you are not the intended
> > recipient, please contact the sender and delete all copies.

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

