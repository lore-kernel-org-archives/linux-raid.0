From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Wed, 24 Mar 2010 19:47:59 -0700
Message-ID: <4877c76c1003241947k63ce9959ta0345012b2556392@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100325113543.0e2124c5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Wed, Mar 24, 2010 at 5:35 PM, Neil Brown <neilb@suse.de> wrote:
>
> Greetings.
> =A0I find myself in the middle of two separate off-list conversations=
 on the
> =A0same topic and it has reached the point where I think the conversa=
tions
> =A0really need to be unite and brought on-list.
>
> =A0So here is my current understanding and thoughts.
>
> =A0The topic is about making rebuild after a failure easier. =A0It st=
rikes me as
> =A0particularly relevant after the link =A0Bill Davidsen recently for=
wards to the
> =A0list:
>
> =A0 =A0 =A0 http://blogs.techrepublic.com.com/opensource/?p=3D1368
>
> =A0The most significant thing I got from this was a complain in the c=
omments
> =A0that managing md raid was too complex and hence error-prone.
>
> =A0I see the issue as breaking down in to two parts.
> =A01/ When a device is hot plugged into the system, is md allowed to =
use it as
> =A0 =A0 a spare for recovery?
> =A02/ If md has a spare device, what set of arrays can it be used in =
if needed.
>
> =A0A typical hot plug event will need to address both of these questi=
ons in
> =A0turn before recovery actually starts.
>
> =A0Part 1.
>
> =A0A newly hotplugged device may have metadata for RAID (0.90, 1.x, I=
MSM, DDF,
> =A0other vendor metadata) or LVM or a filesystem. =A0It might have a =
partition
> =A0table which could be subordinate to or super-ordinate to other met=
adata.
> =A0(i.e. RAID in partitions, or partitions in RAID). =A0The metadata =
may or may
> =A0not be stale. =A0It may or may not match - either strongly or weak=
ly -
> =A0metadata on devices in currently active arrays.
>
> =A0A newly hotplugged device also has a "path" which we can see
> =A0in /dev/disk/by-path. =A0This is somehow indicative of a physical =
location.
> =A0This path may be the same as the path of a device which was recent=
ly
> =A0removed. =A0It might be one of a set of paths which make up a "RAI=
D chassis".
> =A0It might be one of a set of paths one which we happen to find othe=
r RAID
> =A0arrays.
>
> =A0Some how from all of that information we need to decide if md can =
use the
> =A0device without asking, or possibly with a simple yes/no question, =
and we
> =A0need to decide what to actually do with the device.
>
> =A0Options for what to do with the device include:
> =A0 =A0- write an MBR and partition table, then do something as below=
 with
> =A0 =A0 =A0each partition
> =A0 =A0- include the device (or partition) in an array that it was pr=
eviously
> =A0 =A0 =A0part of, but from which it was removed
> =A0 =A0- include the device or partition as a spare in a native-metad=
ata array.
> =A0 =A0- add the device as a spare to a vendor-metadata array
>
> =A0Part 2.
>
> =A0 If we have a spare device and a degraded array we need to know if=
 it is OK
> =A0 to add the device as a hot-spare to that array.
> =A0 Currently this is handled (for native metadata) by 'mdadm --monit=
or' and
> =A0 the =A0spare-groups tag in mdadm.conf.
> =A0 For vendor metadata, if the spare is already in the container the=
n mdmon
> =A0 should handle the spare assignment, but if the spare is in a diff=
erent
> =A0 container, 'mdadm --monitor' should move it to the right containe=
r, but
> =A0 doesn't yet.
>
> =A0 The "spare-group" functionality works but isn't necessarily the e=
asiest
> =A0 way to express the configuration desires. =A0People are likely to=
 want to
> =A0 specify how far a global spare can migrate using physical address=
: path.
>
> =A0 So for example you might specify a group of paths with wildcards =
with the
> =A0 implication that all arrays which contain disks from this group o=
f paths
> =A0 are automatically in the same spare-group.
>
>
> =A0Configuration and State
>
> =A0 I think it is clear that configuration for this should go in mdad=
m.conf.
> =A0 This would at least cover identifying groups of device by path an=
d ways
> =A0 what is allowed to be done to those devices.
> =A0 It is possible that some configuration could be determined by ins=
pecting
> =A0 the hardware directly. =A0e.g. the IMSM code currently looks for =
an Option
> =A0 ROM show confirms that the right Intel controller is present and =
so the
> =A0 system can boot from the IMSM device. =A0It is possible that othe=
r
> =A0 information could be gained this way so that the mdadm.conf confi=
guration
> =A0 would not need to identify paths but alternately identify some
> =A0 platform-specific concept.
>
> =A0 The configuration would have to say what is permitted for hot-plu=
gged
> =A0 devices: =A0nothing, re-add, claim-bare-only, claim-any-unrecogni=
sed
> =A0 The configuration would also describe mobility of spares across
> =A0 different device sets.
>
> =A0 This would add a new line type to mdadm.conf. e.g.
> =A0 =A0 DOMAIN or CHASSIS or DEDICATED or something else.
> =A0 The line would identify
> =A0 =A0 =A0 =A0 some devices by path or platform
> =A0 =A0 =A0 =A0 a metadata type that is expected here
> =A0 =A0 =A0 =A0 what hotplug is allows to do
> =A0 =A0 =A0 =A0 a spare-group that applies to all array which use dev=
ices from this
> =A0 =A0 =A0 =A0 group/domain/chassis/thing
> =A0 =A0 =A0 =A0 source for MBR? =A0template for partitioning? =A0or w=
ould this always
> =A0 =A0 =A0 =A0 =A0 =A0 be copied from some other device in the set i=
f hotplug=3D allowed
> =A0 =A0 =A0 =A0 =A0 =A0 partitioning?
>
> =A0 State required would include
> =A0 =A0 =A0 - where devices have been recently removed from, and what=
 they were in
> =A0 =A0 =A0 =A0 use for
> =A0 =A0 =A0 - which arrays are currently using which device sets, tho=
ugh that can
> =A0 =A0 =A0 =A0 be determined dynamically from inspecting active arra=
ys.
> =A0 =A0 =A0 - ?? partition tables off any devices that are in use so =
if they are
> =A0 =A0 =A0 =A0 removed and an new device added the partition table c=
an be
> =A0 =A0 =A0 =A0 replaced.
>
> =A0Usability
>
> =A0The idea of being able to pull out a device and plug in a replacem=
ent and
> =A0have it all "just work" is a good one. =A0However I don't want to =
be too
> =A0dependent on state that might have been saved from the old device.
> =A0I would like to also be able to point to a new device which didn't=
 exist
> =A0before and say "use this". =A0 mdadm would use the path informatio=
n to decide
> =A0which contain or set of drives was most appropriate, extract
> =A0MBR/partitioning from one of those, impose it on the new device an=
d include
> =A0the device or partitions in the appropriate array.
>
> =A0For RAID over partitions, this assumes a fairly regular configurat=
ion: all
> =A0devices partitioned the same way, and each array build out of a se=
t of
> =A0aligned partitions (e.g. /dev/sd[bcde]2 ).
> =A0One of the strength of md is that you don't have to use such a res=
tricted
> =A0configuration, but I think it would be very hard to reliably "to t=
he right
> =A0thing" with an irregular set up (e.g. a raid1 over a 1T device and=
 2 500GB
> =A0devices in a raid0).
>
> =A0So I think we should firmly limit the range of configurations for =
which
> =A0auto-magic stuff is done. =A0Vendor metadata is already fairly str=
ongly
> =A0defined. =A0We just add a device to the vendor container and let i=
t worry
> =A0about the detail. =A0For native metadata we need to draw a firm li=
ne.
> =A0I think that line should be "all devices partitioned the same" but=
 I
> =A0am open to discussion.
>
> =A0If we have "mdadm --use-this-device-however" without needing to kn=
ow
> =A0anything about pre-existing state, then a hot-remove would just ne=
ed to
> =A0record that the device was used by arrays X and Y. Then on hot plu=
g we could
> =A0 - do nothing
> =A0 - do something if metadata on device allows
> =A0 - do use-this-device-however if there was a recent hot-remove of =
the device
> =A0 - always do use-this-device-however
> =A0depending on configuration.
>
> =A0Implementation
>
> =A0I think we all agree that migrating spares between containers is b=
est done
> =A0by "mdadm --monitor". =A0It needs to be enhanced to intuit spare-g=
roup names
> =A0from "DOMAIN" declarations, and to move spares between vendor cont=
ainers.
>
> =A0For hot-plug, hot-unplug I prefer to use udev triggers. =A0plug ru=
ns
> =A0 =A0mdadm --incremental /dev/whatever
> =A0which would be extended to do other clever things if allowed
> =A0Unplug would run
> =A0 =A0 mdadm --force-remove /dev/whatever
> =A0which finds any arrays containing the device (or partitions?) and
> =A0fail/removes them and records the fact with a timestamp.
>
> =A0However if someone has a convincing reason to build this functiona=
lity
> =A0into =A0"mdadm --monitor" instead using libudev I am willing to li=
sten.
>
> =A0Probably the most important first step is to determine a configura=
tion
> =A0syntax and be sure it is broad enough to cover all needs.
>
> =A0I'm thinking:
> =A0 =A0DOMAIN path=3Dglob-pattern metadata=3Dtype =A0hotplug=3Dmode =A0=
spare-group=3Dname
>
> =A0I explicitly have "path=3D" in case we find there is a need to ide=
ntify
> =A0devices some other way - maybe by control vendor:device or some ot=
her
> =A0content-based approach
> =A0The spare-group name is inherited by any array with devices in thi=
s
> =A0domain as long as that doesn't result it in having two different
> =A0spare-group names.
> =A0I'm not sure if "metadata=3D" is really needed. =A0If all the arra=
ys that use
> =A0these devices have the same metadata, it would be redundant to lis=
t it here.
> =A0If they use different metadata ... then what?
> =A0I guess two different DOMAIN lines could identify the same devices=
 and
> =A0list different metadata types and given them different spare-group
> =A0names. =A0However you cannot support hotplug of bare devices into =
both ...
>
> =A0If it possible for multiple DOMAIN lines to identify the same devi=
ce,
> =A0e.g. by having more or less specific patterns. In this case the sp=
are-group
> =A0names are ignored if they conflict, and the hotplug mode used is t=
he most
> =A0permissive.
>
> =A0hotplug modes are:
> =A0 =A0none =A0- ignore any hotplugged device
> =A0 =A0incr =A0- normal incremental assembly (the default). =A0If the=
 device has
> =A0 =A0 =A0 =A0 metadata that matches an array, try to add it to the =
array
> =A0 =A0replace - If above fails and a device was recently removed fro=
m this
> =A0 =A0 =A0 =A0 same path, add this device to the same array(s) that =
the old devices
> =A0 =A0 =A0 =A0 was part of
> =A0 =A0include - If the above fails and the device has not recognisab=
le metadata
> =A0 =A0 =A0 =A0 add it to any array/container that uses devices in th=
is domain,
> =A0 =A0 =A0 =A0 partitioning first if necessary.
> =A0 =A0force - as above but ignore any pre-existing metadata
>
>
> =A0I'm not sure that all those are needed, or are the best names. =A0=
Names like
> =A0 =A0ignore, reattach, rebuild, rebuild_spare
> =A0have also been suggested.
>
> =A0It might be useful to have a 'partition=3Dtype' flag to specify MB=
R or GPT ??
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
> device is pulled and a replacement added). =A0I'm not convinced of th=
is but am
> happy to hear more explanations.
>
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

My feeling on the entire subject matter is that this is /not/ an easy
decision.  Computers are rarely correct when they guess at what an
administrator wants, and attempting to implement the functionality
within mdadm is prone to many limitations or re-inventing the wheel.

If mdadm / mdmon is part of the process at all, I think it should be
used to either fork an executable (script or otherwise) which invokes
the administrative actions that have been pre-determined.

I believe that the default action should be to do /nothing/.  That is
the only safe thing to do.  If an administrative framework is desired
that seems to fall under a larger project goal which is likely better
covered by programs more aware of the overall system state.  This
route also allows for a range of scalability.

It may be sufficient in an initramfs context to either spawn a shell
or even just wait in a recovery console after the mdadm invocation
returns failure.  It might also be desired to use a very simple
reaction which assumes any spare of sufficient size which is added
should be allocated to the largest or closest comparable area based on
pre-determined preferences.

At the same time, I could see the value in mapping actual physical
locations to an array, remembering any missing or failed device
layouts, and re-creating the same layouts on the new device.  However
those actions are a little above what mdadm should be operating at.

With both of those viewpoints I see the following solution.

The most specific action match is followed.

Action-matches should be restrict-able by path wildcard, simple size
comparisons, AND state for metadata.
As a final deciding factor action-matches should also have an optional
priority value, so that when all else matches one rule out of a set
will be known to run first.

The result of matching an action, once again, should be an external
program or shell to allow for maximum flexibility.

I am not at all opposed to adding good default choices for those
actions in either binary or shell script form.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
