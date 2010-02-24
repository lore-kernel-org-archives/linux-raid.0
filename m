From: Neil Brown <neilb@suse.de>
Subject: Re: md homehost
Date: Thu, 25 Feb 2010 09:30:18 +1100
Message-ID: <20100225093018.12d3e14d@notabene.brown>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d3zulpj7.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: martin f krafft <madduck@madduck.net>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 24 Feb 2010 14:41:16 +0100
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> Neil Brown <neilb@suse.de> writes:
> 
> > On Tue, 23 Feb 2010 07:27:00 +0100
> > martin f krafft <madduck@madduck.net> wrote:
> >> The only issue homehost protects against, I think, is machines that
> >> use /dev/md0 directly from grub.conf or fstab.
> >
> > That is exactly correct.  If no code or config file depends on a name like
> > /dev/mdX or /dev/md/foo, then you don't need to be concerned about the whole
> > homehost thing.
> > You can either mount by fs-uuid, or mount e.g.
> >    /dev/disk/by-id/md-uuid-8fd0af3f:4fbb94ea:12cc2127:f9855db5 
> 
> What if you have two raids (one local, one from the other hosts that
> broke down) and both have LVM on it with /dev/vg/root?
> 
> Shouldn't it only assemble the local raid (as md0 or whatever) and then
> only start the local volume group? If it assembles the remote raid as
> /dev/md127 as well then lvm will have problems and the boot will likely
> (even randomly) go wrong since only one VG can be activated.
> 
> I think it is pretty common for admins to configure LVM to the same
> volume group name on different systems. So if you consider raids being
> pluged into other systems please keep this in mind.

You are entirely correct.  However lvm problems are not my problems.

It has always been my position that the best way to configure md is to
explicitly list your arrays in mdadm.conf.  But people seem to not like this
and want it to all be 'automatic'.  So I do my best to make it as automatic
as possible but still remove as many of the possible confusion that this can
cause as possible.  But I cannot remove them all.

If you move disks around and boot and lvm gets confused because there are two
things call "/dev/vg/root", then I'm sorry but there is nothing I can do
about that.  If you had an mdadm.conf which listed you md arrays, and had
   auto -all
then you can be sure that mdadm would not be contributing to this problem.

NeilBrown
