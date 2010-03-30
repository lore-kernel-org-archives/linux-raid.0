From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Tue, 30 Mar 2010 16:36:52 -0700
Message-ID: <e9c3a7c21003301636y11e4a2bdo4ebfdd5f8c1ea307@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
	 <4BB0ED13.6020507@redhat.com>
	 <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
	 <4BB13830.8070709@redhat.com>
	 <e9c3a7c21003291746o49191295r876c7fef50fe63a5@mail.gmail.com>
	 <4BB2175C.7070201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB2175C.7070201@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 8:23 AM, Doug Ledford <dledford@redhat.com> wro=
te:
> On 03/29/2010 08:46 PM, Dan Williams wrote:
>> This begs the question, why not change the definition of an imsm
>> container to incorporate anything with imsm metadata? =A0This defini=
tely
>> would make spare management easier. =A0This was an early design deci=
sion
>> and had the nice side effect that it lined up naturally with the
>> failure and rebuild boundaries of a family. =A0I could give it more
>> thought, but right now I believe there is a lot riding on this 1:1
>> container-to-family relationship, and I would rather not go there.
>
> I'm fine with the container being family based and not domain based. =
=A0I
> just didn't realize that distinction existed. =A0It's all cleared up =
now ;-)
>

Great.

>>> However, that just means (to me anyway) that I would treat all of t=
he
>>> sata ports as one domain with multiple container arrays in that dom=
ain
>>> just like we can have multiple native md arrays in a domain. =A0If =
a disk
>>> dies and we hot plug a new one, then mdadm would look for the degra=
ded
>>> container present in the domain and add the spare to it. =A0It woul=
d then
>>> be up to mdmon to determine what logical volumes are currently degr=
aded
>>> and slice up the new drive to work as spares for those degraded log=
ical
>>> volumes. =A0Does this sound correct to you, and can mdmon do that a=
lready
>>> or will this need to be added?
>>
>> This sounds correct, and no mdmon cannot do this today. =A0The curre=
nt
>> discussions we (Marcin and I) had with Neil offlist was extending
>> mdadm --monitor to handle spare migration for containers since it
>> already handles spare migration for native md arrays. =A0It will nee=
d
>> some mdmon coordination since mdmon is the only agent that can
>> disambiguate a spare from a stale device at any given point in time.
>
> So we'll need to coordinate on this aspect of things then. =A0I'll ke=
ep
> you updated as I get started implementing this if you want to think
> about how you would like to handle this interaction between mdadm/mdm=
on.

Ok, that sounds like a good split we'll keep you posted as well,

> As far as I can tell, we've reached a fairly decent consensus on thin=
gs.
> =A0But, just to be clear, I'll reiterate that concensus here:
>
> Add a new linetype: DOMAIN with options path=3D (must be specified at
> least once for any domain action other than none and incremental and
> must be something other than a global match for any action other than
> none and incremental) and metadata=3D (specifies the metadata type
> possible for this domain as one of imsm/ddf/md

Why not 0.90 and 1.x for instead of 'md'?  These match the 'name'
attribute of struct superswitch.

> and where for imsm or
> ddf types, we will verify that the path portions of the domain do not
> violate possible platform limitations) and action=3D (where action is
> none, incremental, readd, safe_use, force_use where action is specifi=
c
> to a hotplug when a degraded array in the domain exists and can possi=
bly
> have slightly different meanings depending on whether the path specif=
ies
> a whole disk device or specific partitions on a range of devices

I have been thinking that the path=3D option specifies controller paths=
,
not disk devices.  Something like "pci-0000:00:1f.2-scsi-[0-3]*" to
pick the first 4 ahci ports.  This also purposefully excludes virtual
devices dm/md.  I think we want to limit this functionality to
physical controller ports... or were you looking to incorporate
support for any block device?

> and
> where there is the possibility of adding more options or a new option
> name for the case of adding a hotplug drive to a domain where no arra=
ys
> are degraded, in which case issues such as boot sectors, partition
> tables, hot spare versus grow, etc. must be addressed).
>
> Modify udev rules files to cover the following scenarios (it's
> unfortunate that we have to split things up like this, but in order t=
o
> deal with either bare drives or drives that have things like lvm data
> and we are using force_use, we must trigger on *all* drive hotplug
> events, we must trigger early, and we must override other subsystem's
> possible hotplug actions, otherwise the force_use option will be a no=
op):

Can't we limit the scope to the hotplug events we care about by
filtering the udev scripts based on the current contents of the
configuration file?  We already need a step in the process that
verifies if the configuration heeds the platform constraints.  So,
something like mdadm --activate-domains that validates the
configuration, generates the necessary udev scripts and enables
hotplug.

>
> 1) plugging in a device that already has md raid metadata present
> =A0 a) if the device has metadata corresponding to one of our arrays,
> attempt to do normal incremental add
> =A0 b) if the device has metadata corresponding to one of our arrays,=
 and
> the normal add failed and the options readd, safe_use, or force_use a=
re
> present in the mdadm.conf file, reattempt to add using readd
> =A0 c) if the device has metadata corresponding to one of our arrays,=
 and
> the readd failed, and the options safe_use or force_use are present,
> then do a regular add of the device to the array (possibly with doing=
 a
> preemptive zero-superblock on the device we are adding). =A0This shou=
ld
> never fail.

Yes, but this also reminds me about the multiple superblock case.  It
should usually only happen to people that experiment with different
metadata types, but we should catch and probably ignore drives that
have ambiguous/multiple superblocks.

> =A0 d) if the device has metadata that does not correspond to any arr=
ay
> in the system, and there is a degraded array, and the option force_us=
e
> is present, then quite possibly repartition the device to make the
> partitions match the degraded devices, zero any superblocks, and add =
the
> device to the arrays. =A0BIG FAT WARNING: the force_use option will c=
ause
> you to loose data if you plug in an array disk for another machine wh=
ile
> this machine has degraded arrays.

Let's also limit this to ports that were recently (as specified by a
timeout=3D option to the DOMAIN) unplugged.  This limits the potential
damage.

>
> 2) plugging in a device that doesn't already have md raid metadata
> present but is part of an md domain
> =A0 a) if the device is bare and the option safe_use is present and w=
e
> have degraded arrays, partition the device (if needed) and then add
> partitions to degraded arrays
> =A0 b) if the device is not bare, and the option force_use is present=
 and
> we have degraded arrays, (re)partition the device (if needed) and the=
n
> add partitions to degraded arrays. =A0BIG FAT WARNING: if you enable =
this
> mode, and you hotplug say an LVM volume into your domain when you hav=
e a
> degraded array, kiss your LVM volume goodbye.
>
> Modify udev rules files to deal with device removal. =A0Specifically,=
 we
> need to watch for removal of devices that are part of raid arrays and=
 if
> they weren't failed when they were removed, fail them, and then remov=
e
> them from the array. =A0This is necessary for readd to work. =A0It al=
so
> releases our hold on the scsi device so it can be fully released and =
the
> new device can be added back using the same device name.
>

Nod.

> Modify mdadm -I mode to read the mdadm.conf file for the DOMAIN lines=
 on
> hotplug events and then modify the -I behavior to suit the situation.
> The majority of the hotplug changes mentioned above will actually be
> implemented as part of mdadm -I, we will simply add a few rules to ca=
ll
> mdadm -I in a few new situations, then allow mdadm -I (which has
> unlimited smarts, where as udev rules get very convoluted very quickl=
y
> if you try to make them smart) to actually make the decisions and do =
the
> right thing. =A0This means that effectively, we might just end up cal=
ling
> mdadm -I on every disk hot plug event whether there is md metadata or
> not, but only doing special things when the various conditions above =
are
> met.

Modulo the ability to have a global enable / disable for domains via
something like --activate-domains

>
> Modify mdadm and the spare-group concept of ARRAY lines to coordinate
> spare-group assignments and DOMAIN assignments. =A0We need to know wh=
at to
> do in the event of a conflict between the two. =A0My guess is that th=
is is
> unlikely, but in the end, I think we need to phase out spare-group
> entirely in favor of domain. =A0Since we can't have a conflict withou=
t
> someone adding domain lines to the config file, I would suggest that =
the
> domain assignments override spare-group assignments and we complain
> about the conflict. =A0That way, even though the user obviously inten=
ded
> something specific with spare-group, he also must have intended
> something specific with domain assignments, and as the domain keyword=
 is
> the newest and latest thing, honor the latest wishes and warn about i=
t
> in case they misentered something.

Sounds reasonable.

>
> Modify mdadm/mdmon to enable spare migration between imsm containers =
in
> a domain. =A0Retain mdadm ability to move hot spares between native
> arrays, but make it based on domain now instead of spare-group, and i=
n
> the config settings if someone has spare-group assignments and no dom=
ain
> assignments, then create internal domain entries that mimic the
> spare-group layout so that we can modify the core spare movement code=
 to
> only be concerned with domain entries.
>
> I think that covers it. =A0Do we have a consensus on the general work=
?

I think we have a consensus.  The wrinkle that comes to mind is the
case we talked about before where some ahci ports have been reserved
for jbod support in the DOMAIN configuration.  If the user plugs in an
imsm-metadata disk into a "jbod port" and reboots the option-rom will
assemble the array across the DOMAIN boundary.  You would need to put
explicit "passthrough" metadata on the disk to get the option-rom to
ignore it, but then you couldn't put another metadata type on that
disk.  So maybe we can't support the subset case and need to force the
platform's full expectation of the domain boundaries or honor the
DOMAIN line and let the user figure out/remember why this one raid
member slot does not respond to hotplug events.

Thanks for the detailed write up.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
