From: Neil Brown <neilb@suse.de>
Subject: Re: md homehost
Date: Thu, 25 Feb 2010 18:46:58 +1100
Message-ID: <20100225184658.4df16713@notabene.brown>
References: <20100218044004.GC5136@lapse.rw.madduck.net>
	<20100218161012.704b43a6@notabene.brown>
	<20100218052145.GA7178@lapse.rw.madduck.net>
	<20100218163448.0d3f3107@notabene.brown>
	<20100219004237.GC25162@lapse.rw.madduck.net>
	<20100219091619.GA2964@lazy.lzy>
	<20100221174007.GB19058@lapse.rw.madduck.net>
	<20100221201304.GB2570@lazy.lzy>
	<20100222091632.GE2641@lapse.rw.madduck.net>
	<20100223133028.279e0174@notabene.brown>
	<20100223062700.GB19666@lapse.rw.madduck.net>
	<20100224111006.7024c84e@notabene.brown>
	<87d3zulpj7.fsf@frosties.localdomain>
	<20100225093018.12d3e14d@notabene.brown>
	<87eik94wg1.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eik94wg1.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: martin f krafft <madduck@madduck.net>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 25 Feb 2010 08:16:14 +0100
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> Neil Brown <neilb@suse.de> writes:
> 
> > On Wed, 24 Feb 2010 14:41:16 +0100
> > Goswin von Brederlow <goswin-v-b@web.de> wrote:
> >
> >> Neil Brown <neilb@suse.de> writes:
> >> 
> >> > On Tue, 23 Feb 2010 07:27:00 +0100
> >> > martin f krafft <madduck@madduck.net> wrote:
> >> >> The only issue homehost protects against, I think, is machines that
> >> >> use /dev/md0 directly from grub.conf or fstab.
> >> >
> >> > That is exactly correct.  If no code or config file depends on a name like
> >> > /dev/mdX or /dev/md/foo, then you don't need to be concerned about the whole
> >> > homehost thing.
> >> > You can either mount by fs-uuid, or mount e.g.
> >> >    /dev/disk/by-id/md-uuid-8fd0af3f:4fbb94ea:12cc2127:f9855db5 
> >> 
> >> What if you have two raids (one local, one from the other hosts that
> >> broke down) and both have LVM on it with /dev/vg/root?
> >> 
> >> Shouldn't it only assemble the local raid (as md0 or whatever) and then
> >> only start the local volume group? If it assembles the remote raid as
> >> /dev/md127 as well then lvm will have problems and the boot will likely
> >> (even randomly) go wrong since only one VG can be activated.
> >> 
> >> I think it is pretty common for admins to configure LVM to the same
> >> volume group name on different systems. So if you consider raids being
> >> pluged into other systems please keep this in mind.
> >
> > You are entirely correct.  However lvm problems are not my problems.
> >
> > It has always been my position that the best way to configure md is to
> > explicitly list your arrays in mdadm.conf.  But people seem to not like this
> > and want it to all be 'automatic'.  So I do my best to make it as automatic
> > as possible but still remove as many of the possible confusion that this can
> > cause as possible.  But I cannot remove them all.
> >
> > If you move disks around and boot and lvm gets confused because there are two
> > things call "/dev/vg/root", then I'm sorry but there is nothing I can do
> > about that.  If you had an mdadm.conf which listed you md arrays, and had
> >    auto -all
> > then you can be sure that mdadm would not be contributing to this problem.
> >
> > NeilBrown
> 
> Yes you can do something about it: Only start the raid arrays with the
> correct homehost.

This is what 'homehost' originally did, but I got a lot of push-back on that.
I added the "auto" line in mdadm.conf so that the admin could choose what
happens.
If the particular metadata type is enabled on the auto line, the the array is
assembled with a random name.  If it is disabled, it is not assembled at all
(unless explicitly listed in mdadm.conf).
I'm not sure exactly how 'auto' interacts with 'homehost'.  The documentation
I wrote only talks about arrays listed in mdadm.conf or on the command line,
not arrays with a valid homehost.  I guess I should check..... I think I want
"auto -all" to still assemble arrays with a valid homehost.  I'll confirm
that before I release 3.1.2.

> 
> If the homehost is only used to decide wether the prefered minor in the
> metadata is used for the device name then I feel the feature is entirely
> useless. It would only help in "stupid" configurations, i.e. when you
> use the device name directly.

Yes.

> 
> Another scenario where starting a raid with the wrong homehost would be
> bad is when the raid is degraded and you have a global spare. You
> probably wouldn't want the global spare of one host to be used to repair
> a raid of another host.

I only support global spares that are explicitly listed in mdadm.conf, so
currently this couldn't happen.  One day some one is going to ask for
auto-configure global spares.  Then I'll have to worry about this (or just
say "no").

> 
> MfG
>         Goswin
> 
> PS: If a raid is not listed in mdadm.conf doesn't it currently start too
> but the name can be random?

It depends on the "auto" line in mdadm.conf

Thanks,
NeilBrown
