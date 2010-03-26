From: "Majed B." <majedb@gmail.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Fri, 26 Mar 2010 10:52:07 +0300
Message-ID: <70ed7c3e1003260052q3b65c76taa2f4d992c6f7eca@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100325113543.0e2124c5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

Why not treat this similar to how hardware RAID manages disks & spares?
Disk has no metadata -> new -> use as spare.
Disk has metadata -> array exists -> add to array.
Disk has metadata -> array doesn't exist (disk came from another
system) -> sit idle & wait for an admin to do the work.

As to identify disks and know which disks were removed and put back to
an array, there's the metadata & there's the disk's serial number
which can obtained using hdparm. I also think that all disks now
include a World Wide Number (WWN) which is more suitable for use in
this case than a disk's serial number.

Some people rant because they see things only from their own
perspective and assume that there's no case or scenario but their own.
So don't pay too much attention :p

Here's a scenario: What if I had an existing RAID1 array of 3 disks. I
bought a new disk and I wanted to make a new array in the system. So I
add the new disk, and I want to use one of the RAID1 array disks in
this new array.

Being lazy, instead of failing the disk then removing it using the
console, I just removed it from the port then added it again. I
certainly don't want mdadm to start resyncing, forcing me to wait!

As you can see in this scenario, it includes the situation where an
admin is a lazy bum who is going to use the command line anyway to
make the new array but didn't bother to properly remove the disk he
wanted. And there's the case of the newly added disk.

Why assume things & guess when an admin should know what to do?
I certainly don't want to risk my arrays in mdadm guessing for me. And
keep one thing in mind: How often do people interact with storage
systems?

If I configure mdadm today, the next I may want to add or replace a
disk would be a year later. I certainly would have forgotten whatever
configuration was there! And depending on the situation I have, I
certainly wouldn't want mdadm to guess.

On Thu, Mar 25, 2010 at 3:35 AM, Neil Brown <neilb@suse.de> wrote:
>
> Greetings.
> =C2=A0I find myself in the middle of two separate off-list conversati=
ons on the
> =C2=A0same topic and it has reached the point where I think the conve=
rsations
> =C2=A0really need to be unite and brought on-list.
>
> =C2=A0So here is my current understanding and thoughts.
>
> =C2=A0The topic is about making rebuild after a failure easier. =C2=A0=
It strikes me as
> =C2=A0particularly relevant after the link =C2=A0Bill Davidsen recent=
ly forwards to the
> =C2=A0list:
>
> =C2=A0 =C2=A0 =C2=A0 http://blogs.techrepublic.com.com/opensource/?p=3D=
1368
>
> =C2=A0The most significant thing I got from this was a complain in th=
e comments
> =C2=A0that managing md raid was too complex and hence error-prone.
>
> =C2=A0I see the issue as breaking down in to two parts.
> =C2=A01/ When a device is hot plugged into the system, is md allowed =
to use it as
> =C2=A0 =C2=A0 a spare for recovery?
> =C2=A02/ If md has a spare device, what set of arrays can it be used =
in if needed.
>
> =C2=A0A typical hot plug event will need to address both of these que=
stions in
> =C2=A0turn before recovery actually starts.
>
> =C2=A0Part 1.
>
> =C2=A0A newly hotplugged device may have metadata for RAID (0.90, 1.x=
, IMSM, DDF,
> =C2=A0other vendor metadata) or LVM or a filesystem. =C2=A0It might h=
ave a partition
> =C2=A0table which could be subordinate to or super-ordinate to other =
metadata.
> =C2=A0(i.e. RAID in partitions, or partitions in RAID). =C2=A0The met=
adata may or may
> =C2=A0not be stale. =C2=A0It may or may not match - either strongly o=
r weakly -
> =C2=A0metadata on devices in currently active arrays.
>
> =C2=A0A newly hotplugged device also has a "path" which we can see
> =C2=A0in /dev/disk/by-path. =C2=A0This is somehow indicative of a phy=
sical location.
> =C2=A0This path may be the same as the path of a device which was rec=
ently
> =C2=A0removed. =C2=A0It might be one of a set of paths which make up =
a "RAID chassis".
> =C2=A0It might be one of a set of paths one which we happen to find o=
ther RAID
> =C2=A0arrays.
>
> =C2=A0Some how from all of that information we need to decide if md c=
an use the
> =C2=A0device without asking, or possibly with a simple yes/no questio=
n, and we
> =C2=A0need to decide what to actually do with the device.
>
> =C2=A0Options for what to do with the device include:
> =C2=A0 =C2=A0- write an MBR and partition table, then do something as=
 below with
> =C2=A0 =C2=A0 =C2=A0each partition
> =C2=A0 =C2=A0- include the device (or partition) in an array that it =
was previously
> =C2=A0 =C2=A0 =C2=A0part of, but from which it was removed
> =C2=A0 =C2=A0- include the device or partition as a spare in a native=
-metadata array.
> =C2=A0 =C2=A0- add the device as a spare to a vendor-metadata array
>
> =C2=A0Part 2.
>
> =C2=A0 If we have a spare device and a degraded array we need to know=
 if it is OK
> =C2=A0 to add the device as a hot-spare to that array.
> =C2=A0 Currently this is handled (for native metadata) by 'mdadm --mo=
nitor' and
> =C2=A0 the =C2=A0spare-groups tag in mdadm.conf.
> =C2=A0 For vendor metadata, if the spare is already in the container =
then mdmon
> =C2=A0 should handle the spare assignment, but if the spare is in a d=
ifferent
> =C2=A0 container, 'mdadm --monitor' should move it to the right conta=
iner, but
> =C2=A0 doesn't yet.
>
> =C2=A0 The "spare-group" functionality works but isn't necessarily th=
e easiest
> =C2=A0 way to express the configuration desires. =C2=A0People are lik=
ely to want to
> =C2=A0 specify how far a global spare can migrate using physical addr=
ess: path.
>
> =C2=A0 So for example you might specify a group of paths with wildcar=
ds with the
> =C2=A0 implication that all arrays which contain disks from this grou=
p of paths
> =C2=A0 are automatically in the same spare-group.
>
>
> =C2=A0Configuration and State
>
> =C2=A0 I think it is clear that configuration for this should go in m=
dadm.conf.
> =C2=A0 This would at least cover identifying groups of device by path=
 and ways
> =C2=A0 what is allowed to be done to those devices.
> =C2=A0 It is possible that some configuration could be determined by =
inspecting
> =C2=A0 the hardware directly. =C2=A0e.g. the IMSM code currently look=
s for an Option
> =C2=A0 ROM show confirms that the right Intel controller is present a=
nd so the
> =C2=A0 system can boot from the IMSM device. =C2=A0It is possible tha=
t other
> =C2=A0 information could be gained this way so that the mdadm.conf co=
nfiguration
> =C2=A0 would not need to identify paths but alternately identify some
> =C2=A0 platform-specific concept.
>
> =C2=A0 The configuration would have to say what is permitted for hot-=
plugged
> =C2=A0 devices: =C2=A0nothing, re-add, claim-bare-only, claim-any-unr=
ecognised
> =C2=A0 The configuration would also describe mobility of spares acros=
s
> =C2=A0 different device sets.
>
> =C2=A0 This would add a new line type to mdadm.conf. e.g.
> =C2=A0 =C2=A0 DOMAIN or CHASSIS or DEDICATED or something else.
> =C2=A0 The line would identify
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 some devices by path or platform
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 a metadata type that is expected here
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 what hotplug is allows to do
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 a spare-group that applies to all array w=
hich use devices from this
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 group/domain/chassis/thing
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 source for MBR? =C2=A0template for partit=
ioning? =C2=A0or would this always
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 be copied from some other d=
evice in the set if hotplug=3D allowed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 partitioning?
>
> =C2=A0 State required would include
> =C2=A0 =C2=A0 =C2=A0 - where devices have been recently removed from,=
 and what they were in
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 use for
> =C2=A0 =C2=A0 =C2=A0 - which arrays are currently using which device =
sets, though that can
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 be determined dynamically from inspecting=
 active arrays.
> =C2=A0 =C2=A0 =C2=A0 - ?? partition tables off any devices that are i=
n use so if they are
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 removed and an new device added the parti=
tion table can be
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 replaced.
>
> =C2=A0Usability
>
> =C2=A0The idea of being able to pull out a device and plug in a repla=
cement and
> =C2=A0have it all "just work" is a good one. =C2=A0However I don't wa=
nt to be too
> =C2=A0dependent on state that might have been saved from the old devi=
ce.
> =C2=A0I would like to also be able to point to a new device which did=
n't exist
> =C2=A0before and say "use this". =C2=A0 mdadm would use the path info=
rmation to decide
> =C2=A0which contain or set of drives was most appropriate, extract
> =C2=A0MBR/partitioning from one of those, impose it on the new device=
 and include
> =C2=A0the device or partitions in the appropriate array.
>
> =C2=A0For RAID over partitions, this assumes a fairly regular configu=
ration: all
> =C2=A0devices partitioned the same way, and each array build out of a=
 set of
> =C2=A0aligned partitions (e.g. /dev/sd[bcde]2 ).
> =C2=A0One of the strength of md is that you don't have to use such a =
restricted
> =C2=A0configuration, but I think it would be very hard to reliably "t=
o the right
> =C2=A0thing" with an irregular set up (e.g. a raid1 over a 1T device =
and 2 500GB
> =C2=A0devices in a raid0).
>
> =C2=A0So I think we should firmly limit the range of configurations f=
or which
> =C2=A0auto-magic stuff is done. =C2=A0Vendor metadata is already fair=
ly strongly
> =C2=A0defined. =C2=A0We just add a device to the vendor container and=
 let it worry
> =C2=A0about the detail. =C2=A0For native metadata we need to draw a f=
irm line.
> =C2=A0I think that line should be "all devices partitioned the same" =
but I
> =C2=A0am open to discussion.
>
> =C2=A0If we have "mdadm --use-this-device-however" without needing to=
 know
> =C2=A0anything about pre-existing state, then a hot-remove would just=
 need to
> =C2=A0record that the device was used by arrays X and Y. Then on hot =
plug we could
> =C2=A0 - do nothing
> =C2=A0 - do something if metadata on device allows
> =C2=A0 - do use-this-device-however if there was a recent hot-remove =
of the device
> =C2=A0 - always do use-this-device-however
> =C2=A0depending on configuration.
>
> =C2=A0Implementation
>
> =C2=A0I think we all agree that migrating spares between containers i=
s best done
> =C2=A0by "mdadm --monitor". =C2=A0It needs to be enhanced to intuit s=
pare-group names
> =C2=A0from "DOMAIN" declarations, and to move spares between vendor c=
ontainers.
>
> =C2=A0For hot-plug, hot-unplug I prefer to use udev triggers. =C2=A0p=
lug runs
> =C2=A0 =C2=A0mdadm --incremental /dev/whatever
> =C2=A0which would be extended to do other clever things if allowed
> =C2=A0Unplug would run
> =C2=A0 =C2=A0 mdadm --force-remove /dev/whatever
> =C2=A0which finds any arrays containing the device (or partitions?) a=
nd
> =C2=A0fail/removes them and records the fact with a timestamp.
>
> =C2=A0However if someone has a convincing reason to build this functi=
onality
> =C2=A0into =C2=A0"mdadm --monitor" instead using libudev I am willing=
 to listen.
>
> =C2=A0Probably the most important first step is to determine a config=
uration
> =C2=A0syntax and be sure it is broad enough to cover all needs.
>
> =C2=A0I'm thinking:
> =C2=A0 =C2=A0DOMAIN path=3Dglob-pattern metadata=3Dtype =C2=A0hotplug=
=3Dmode =C2=A0spare-group=3Dname
>
> =C2=A0I explicitly have "path=3D" in case we find there is a need to =
identify
> =C2=A0devices some other way - maybe by control vendor:device or some=
 other
> =C2=A0content-based approach
> =C2=A0The spare-group name is inherited by any array with devices in =
this
> =C2=A0domain as long as that doesn't result it in having two differen=
t
> =C2=A0spare-group names.
> =C2=A0I'm not sure if "metadata=3D" is really needed. =C2=A0If all th=
e arrays that use
> =C2=A0these devices have the same metadata, it would be redundant to =
list it here.
> =C2=A0If they use different metadata ... then what?
> =C2=A0I guess two different DOMAIN lines could identify the same devi=
ces and
> =C2=A0list different metadata types and given them different spare-gr=
oup
> =C2=A0names. =C2=A0However you cannot support hotplug of bare devices=
 into both ...
>
> =C2=A0If it possible for multiple DOMAIN lines to identify the same d=
evice,
> =C2=A0e.g. by having more or less specific patterns. In this case the=
 spare-group
> =C2=A0names are ignored if they conflict, and the hotplug mode used i=
s the most
> =C2=A0permissive.
>
> =C2=A0hotplug modes are:
> =C2=A0 =C2=A0none =C2=A0- ignore any hotplugged device
> =C2=A0 =C2=A0incr =C2=A0- normal incremental assembly (the default). =
=C2=A0If the device has
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 metadata that matches an array, try to ad=
d it to the array
> =C2=A0 =C2=A0replace - If above fails and a device was recently remov=
ed from this
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 same path, add this device to the same ar=
ray(s) that the old devices
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 was part of
> =C2=A0 =C2=A0include - If the above fails and the device has not reco=
gnisable metadata
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 add it to any array/container that uses d=
evices in this domain,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 partitioning first if necessary.
> =C2=A0 =C2=A0force - as above but ignore any pre-existing metadata
>
>
> =C2=A0I'm not sure that all those are needed, or are the best names. =
=C2=A0Names like
> =C2=A0 =C2=A0ignore, reattach, rebuild, rebuild_spare
> =C2=A0have also been suggested.
>
> =C2=A0It might be useful to have a 'partition=3Dtype' flag to specify=
 MBR or GPT ??
>
>
> There, I think that just about covers everything relevant from the va=
rious
> conversations.
> Please feel free to disagree or suggest new use cases or explain why =
this
> would not work or would not be ideal.
> There was a suggestion that more state needed to be stored to support
> auto-rebuild (detail of each device so they can be recovered exactly =
after a
> device is pulled and a replacement added). =C2=A0I'm not convinced of=
 this but am
> happy to hear more explanations.
>
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
