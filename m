From: Neil Brown <neilb@suse.de>
Subject: Re: md homehost (was: Bug#567468: (boot time consequences of) Linux
 mdadm superblock) question.
Date: Wed, 24 Feb 2010 11:10:06 +1100
Message-ID: <20100224111006.7024c84e@notabene.brown>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100223062700.GB19666@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 23 Feb 2010 07:27:00 +0100
martin f krafft <madduck@madduck.net> wrote:

> also sprach Neil Brown <neilb@suse.de> [2010.02.23.0330 +0100]:
> > The problem to protect against is any consequence of rearranging
> > devices while the host is off, including attaching devices that
> > previously were attached to a different computer.
> 
> How often does this happen, and how grave/dangerous are the effects?

a/ no idea.
b/ it all depends...
  It is the sort of thing that happens when something has just gone
  drastically wrong and you need to stitch things back together again as
  quickly as you can.  You aren't exactly panicing, but you are probably
  hasty and don't want anything else to go wrong.

  If the array from the 'other' machine with the same name has very different
  content, then things could go wrong in various different ways if we
  depended on that name.
  It is true that the admin would have to by physically present and could
  presumably get a console and 'fix' things.  But it would be best if they
  didn't have too.  They may not even know clearly what to do to 'fix' things
  - because it always worked perfectly before, but this time when in a
    particular hurry, something strange goes wrongs.  I've been there, I
    don't want to inflict it on others.

> 
> > But if '/' is mounted by a name in /dev/md/, I want to be sure
> > mdadm puts the correct array at that name no matter what other
> > arrays might be visible.
> 
> Of course it would be nice if this happened, but wouldn't it be
> acceptable to assume that if someone swaps drives between machines
> that they ought to know how to deal with the consequences, or at
> least be ready to tae additional steps to make sure the system still
> boots as desired?

No.  We cannot assume that an average sys-admin will have a deep knowledge of
md and mdadm.  Many do, many don't.  But in either case the behaviour must be
predictable.
After all, Debian is for "when you have better things to do than fixing
systems"

> 
> Even if the wrong array appeared as /dev/md0 and was mounted as root
> device, is there any actual problem, other than inconvenience?
> Remember that the person who has previously swapped the drives is
> physically in front of (or behind ;)) the machine.
> 
> I am unconvinced. I think we should definitely switch to using
> filesystem-UUIDs over device names, and that is the only real
> solution to the problem, no?
> 

What exactly are you unconvinced of?
I agree completely that mounting filesystems by UUID is the right way to go.
(I also happen to think that assembly md arrays by UUID is the right way to
go too, but while people seem happy to put fs uuids in /etc/fstab, they seem
less happy to put md uuids in /etc/mdadm.conf).

As you say in another email:

> The only issue homehost protects against, I think, is machines that
> use /dev/md0 directly from grub.conf or fstab.

That is exactly correct.  If no code or config file depends on a name like
/dev/mdX or /dev/md/foo, then you don't need to be concerned about the whole
homehost thing.
You can either mount by fs-uuid, or mount e.g.
   /dev/disk/by-id/md-uuid-8fd0af3f:4fbb94ea:12cc2127:f9855db5 


NeilBrown
