From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: md homehost
Date: Thu, 25 Feb 2010 00:33:31 -0800
Message-ID: <4877c76c1002250033o714913dcnaf8970c9aca5e4dd@mail.gmail.com>
References: <20100218044004.GC5136@lapse.rw.madduck.net>
	 <20100221201304.GB2570@lazy.lzy>
	 <20100222091632.GE2641@lapse.rw.madduck.net>
	 <20100223133028.279e0174@notabene.brown>
	 <20100223062700.GB19666@lapse.rw.madduck.net>
	 <20100224111006.7024c84e@notabene.brown>
	 <87d3zulpj7.fsf@frosties.localdomain>
	 <20100225093018.12d3e14d@notabene.brown>
	 <87eik94wg1.fsf@frosties.localdomain>
	 <20100225184658.4df16713@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100225184658.4df16713@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, martin f krafft <madduck@madduck.net>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 24, 2010 at 11:46 PM, Neil Brown <neilb@suse.de> wrote:
> On Thu, 25 Feb 2010 08:16:14 +0100
> Goswin von Brederlow <goswin-v-b@web.de> wrote:
>
>> Neil Brown <neilb@suse.de> writes:
>>
>> > On Wed, 24 Feb 2010 14:41:16 +0100
>> > Goswin von Brederlow <goswin-v-b@web.de> wrote:
>> >
>> >> Neil Brown <neilb@suse.de> writes:
>> >>
>> >> > On Tue, 23 Feb 2010 07:27:00 +0100
>> >> > martin f krafft <madduck@madduck.net> wrote:
>> >> >> The only issue homehost protects against, I think, is machines=
 that
>> >> >> use /dev/md0 directly from grub.conf or fstab.
>> >> >
>> >> > That is exactly correct. =A0If no code or config file depends o=
n a name like
>> >> > /dev/mdX or /dev/md/foo, then you don't need to be concerned ab=
out the whole
>> >> > homehost thing.
>> >> > You can either mount by fs-uuid, or mount e.g.
>> >> > =A0 =A0/dev/disk/by-id/md-uuid-8fd0af3f:4fbb94ea:12cc2127:f9855=
db5
>> >>
>> >> What if you have two raids (one local, one from the other hosts t=
hat
>> >> broke down) and both have LVM on it with /dev/vg/root?
>> >>
>> >> Shouldn't it only assemble the local raid (as md0 or whatever) an=
d then
>> >> only start the local volume group? If it assembles the remote rai=
d as
>> >> /dev/md127 as well then lvm will have problems and the boot will =
likely
>> >> (even randomly) go wrong since only one VG can be activated.
>> >>
>> >> I think it is pretty common for admins to configure LVM to the sa=
me
>> >> volume group name on different systems. So if you consider raids =
being
>> >> pluged into other systems please keep this in mind.
>> >
>> > You are entirely correct. =A0However lvm problems are not my probl=
ems.
>> >
>> > It has always been my position that the best way to configure md i=
s to
>> > explicitly list your arrays in mdadm.conf. =A0But people seem to n=
ot like this
>> > and want it to all be 'automatic'. =A0So I do my best to make it a=
s automatic
>> > as possible but still remove as many of the possible confusion tha=
t this can
>> > cause as possible. =A0But I cannot remove them all.
>> >
>> > If you move disks around and boot and lvm gets confused because th=
ere are two
>> > things call "/dev/vg/root", then I'm sorry but there is nothing I =
can do
>> > about that. =A0If you had an mdadm.conf which listed you md arrays=
, and had
>> > =A0 =A0auto -all
>> > then you can be sure that mdadm would not be contributing to this =
problem.
>> >
>> > NeilBrown
>>
>> Yes you can do something about it: Only start the raid arrays with t=
he
>> correct homehost.
>
> This is what 'homehost' originally did, but I got a lot of push-back =
on that.
> I added the "auto" line in mdadm.conf so that the admin could choose =
what
> happens.
> If the particular metadata type is enabled on the auto line, the the =
array is
> assembled with a random name. =A0If it is disabled, it is not assembl=
ed at all
> (unless explicitly listed in mdadm.conf).
> I'm not sure exactly how 'auto' interacts with 'homehost'. =A0The doc=
umentation
> I wrote only talks about arrays listed in mdadm.conf or on the comman=
d line,
> not arrays with a valid homehost. =A0I guess I should check..... I th=
ink I want
> "auto -all" to still assemble arrays with a valid homehost. =A0I'll c=
onfirm
> that before I release 3.1.2.
>
>>
>> If the homehost is only used to decide wether the prefered minor in =
the
>> metadata is used for the device name then I feel the feature is enti=
rely
>> useless. It would only help in "stupid" configurations, i.e. when yo=
u
>> use the device name directly.
>
> Yes.
>
>>
>> Another scenario where starting a raid with the wrong homehost would=
 be
>> bad is when the raid is degraded and you have a global spare. You
>> probably wouldn't want the global spare of one host to be used to re=
pair
>> a raid of another host.
>
> I only support global spares that are explicitly listed in mdadm.conf=
, so
> currently this couldn't happen. =A0One day some one is going to ask f=
or
> auto-configure global spares. =A0Then I'll have to worry about this (=
or just
> say "no").
>
>>
>> MfG
>> =A0 =A0 =A0 =A0 Goswin
>>
>> PS: If a raid is not listed in mdadm.conf doesn't it currently start=
 too
>> but the name can be random?
>
> It depends on the "auto" line in mdadm.conf
>
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I've always tried to assign volume-groups a host-unique name anyway.
Though I don't currently run enough systems to demand a formal
approach, I imagine a dedicated hostname within the VG name would
work.  You could then use a pattern like sys-${HOSTNAME} or sys-*/ to
obtain the hostname on a nominal basis; though obviously if working on
multiple 'system' volume groups at a time the * method fails...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
