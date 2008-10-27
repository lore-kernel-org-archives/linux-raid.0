From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 13:41:55 +0100
Message-ID: <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18692.62860.863118.727187@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Sun, Oct 26, 2008 at 23:56, Neil Brown <neilb@suse.de> wrote:
>  Device naming in mdadm is a bit of a mess.

>  In 2.6.28, partitioned devices (mdp) wont be needed any more as md
>  will make use of the "extended partition" functionality recently
>  added.

You mean the extended minor space, right? Or the extended partitions,
which are a format in a msdos table?

>  1/ The only device nodes created will be /dev/mdX and /dev/md_dX
>    along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
>    These will be created by mdadm in accordance with the "--auto"
>    flag unless something in mdadm.conf says to leave it to udev.
>    In that case, mdadm will create a temporary node
>    (/dev/.mdadm.whatever) and remove it once udev has created the
>    real thing.

Sounds fine, if mdadm needs a device node. It could also wait for udev
to have the node created, but having a temporary node sounds fine, as
long as it will not clash with anything udev is creating.

>  2/ There will be various symlinks to these devices.
>    a/ if "symlinks=yes" is given in mdadm.conf, symlinks from
>         /dev/md/X or /dev/md/dX will be created.
>    b/ if udev is configured like on Debian,
>              /dev/disk/by-id/md-name-XXXX
>        and   /dev/disk/by-id/md-uuid-UUUU
>       will be created (by udev).

Yes, almost all distros have that.

>    I'm contemplating creating a link based on the metadata type with
>    a sequential number. e.g. /dev/md/ddf1 or /dev/md/imsm2.
>    I'm not sure if there should be in /dev/md/ or directly in /dev/.
>    I'm also not sure if I should leave the creation to udev, and
>    whether I should use a small sequential number, or just whatever
>    number was allocated as the minor number of the device.

There is intentionally no support for enumeration in udev, it will
just not work and such numbers/links are not reproducible in hotplug
environments, and therefore totally useless, and do much more harm
than good.

Nothing must ever depend on enumeration, or minor numbers, if these
properties can not made persistent, attached  to the device itself, so
that it will always show up with the same number forever. Better do
not even start such an idea, and leave the kernel name as the primary
"random" number, instead of creating new randomness on top.

>  4/ When we stop an array, mdadm will remove anything from /dev that
>    it probably created.

Sure, but only if mdadm has it created.

>    In particular, it will remove the device node as described in 1,
>    any partitions, and any symlinks in /dev or /dev/md which point to
>    any of those.  I need to be certain that this won't confuse udev.

You must never touch anything that udev has created. It must be driven
by kernel "add/remove/change" events.

>  1/ People want auto-assembly.  I've always fought against it (we
>    don't auto-mount all filesystems do we?).

Some systems do automount all devices. Most systems do only hotplug
devices which are not listed in /etc/fstab. Expect in the future that
there will always be auto-assembly and also auto-mounting to some
degree. All the newer storage buses, like iSCSI and such will always
need  auto-mounting on device discovery, and not work with any
bootup-script logic.

>    But it is a loosing
>    battle.  And on a modern desktop, when you plug in a new drive the
>    filesystem is automatically mounted.  So my argument is falling
>    apart.

Yes, we will need to support that as a common setup.

> I'm also wondering if I should include a udev 'rules' file for md in
> the mdadm distribution.  Obviously it would be no more than a
> recommendation, but it might give me a voice in guiding how udev
> interacted with mdadm.

Definitely, it should carry a udev rules file which instructs udev to
create all intended symlinks and also supports the raid auto-assembly
setup. It should not mount anything by default though.

I'm happy, to see you working on next-generation mdadm. I like to see
a better integration with udev, and especially, if mdadm detects a
running udev, not to mess around in /dev in any way, but leave the
names in /dev to instructions in udev rules. Temporary nodes are fine,
as long as they don't conflict with anything else, and get removed
after they are not needed anymore. All updates to symlinks and such
should be done by "change" events from the kernel, which instructs
udev to update all the links, and not by touching anything in /dev
from mdadm.

Do you think mdadm will stay a program only, called by udev/the user,
or will a port of its functionality live in a daemon?

Thanks,
Kay
