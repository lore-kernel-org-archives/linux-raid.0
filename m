From: Neil Brown <neilb@suse.de>
Subject: Re: md homehost (was: Bug#567468: (boot time consequences of) Linux
 mdadm superblock) question.
Date: Tue, 23 Feb 2010 13:30:28 +1100
Message-ID: <20100223133028.279e0174@notabene.brown>
References: <20100218032610.GB1991@lapse.rw.madduck.net>
	<1266465801.11568.183.camel@localhost.localdomain>
	<20100218044004.GC5136@lapse.rw.madduck.net>
	<20100218161012.704b43a6@notabene.brown>
	<20100218052145.GA7178@lapse.rw.madduck.net>
	<20100218163448.0d3f3107@notabene.brown>
	<20100219004237.GC25162@lapse.rw.madduck.net>
	<20100219091619.GA2964@lazy.lzy>
	<20100221174007.GB19058@lapse.rw.madduck.net>
	<20100221201304.GB2570@lazy.lzy>
	<20100222091632.GE2641@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100222091632.GE2641@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 22 Feb 2010 10:16:32 +0100
martin f krafft <madduck@madduck.net> wrote:

> also sprach Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> [2010.02.21.2113 +0100]:
> > I do not see how the "homehost" plays a role, here.
> 
> Neil,
> 
> Could you please put forth the argument for why the homehost must
> match, and why unconditional auto-assembly is not desirable?
> Realistically, what problems are we protecting against?
> 

The problem to protect against is any consequence of rearranging devices
while the host is off, including attaching devices that previously were
attached to a different computer.

mdadm will currently assembly any array that it finds, but will not give a
predictable name to anything that looks like it might be imported from a
different host.
So if you have 'md0' on each of two computers, one computer dies and you move
the devices from that computer to the other, then as long as the bios boots
of the right drive, mdadm will assemble the local array as 'md0' and the
other array as 'something else'.

There are two ways that mdadm determines than array is 'local'.
1/ is the uuid listed against an array in mdadm.conf
2/ is the 'homehost' encoded in the metadata.

If either of those is true, the array is local and gets a predictable name.
If neither, the name gets an _%d suffix.

This is only an issue if you use device name (.e.g /dev/md0 or /dev/md/root)
to mount the root filesystem.
If you use mount-by-uuid then it clearly doesn't matter what name mdadm
assembles the array under.  In that case, the fs UUID (stored on the
initramfs or similar) will assure the necessary uniqueness and mdadm need not
worry about homehost.

But if '/' is mounted by a name in /dev/md/, I want to be sure mdadm puts the
correct array at that name no matter what other arrays might be visible.

Does that clarify things enough?

NeilBrown
