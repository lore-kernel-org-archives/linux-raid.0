From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 01:03:38 +0100
Message-ID: <ac3eb2510810271703k7d9c97caob0f1d2eee28b8b7@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
	 <18694.19834.523955.697048@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18694.19834.523955.697048@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Tue, Oct 28, 2008 at 00:23, Neil Brown <neilb@suse.de> wrote:
> On Monday October 27, kay.sievers@vrfy.org wrote:
>> On Sun, Oct 26, 2008 at 23:56, Neil Brown <neilb@suse.de> wrote:
>> >  Device naming in mdadm is a bit of a mess.
>> >  2/ There will be various symlinks to these devices.
>> >    a/ if "symlinks=yes" is given in mdadm.conf, symlinks from
>> >         /dev/md/X or /dev/md/dX will be created.
>> >    b/ if udev is configured like on Debian,
>> >              /dev/disk/by-id/md-name-XXXX
>> >        and   /dev/disk/by-id/md-uuid-UUUU
>> >       will be created (by udev).
>>
>> Yes, almost all distros have that.
>
> But in different places.
> Debian has /etc/udev/rules
> openSUSE has /lib/udev/rules
>
> I love standards.  There are so many to choose from. :-)

They are all valid and needed. You should install in
/lib/udev/rules.d/ if the rule is not supposed to be edited by the
user.

All stuff in /lib/udev/rules.d/ is not marked as "config" in the
package and will be overwritten with a udev update, regardless if the
content has been edited or not. We moved the "default" rules there
because people edited the files in /etc and wondered why stuff broke
in weird ways on updates. /etc/udev/rules.d/ is for "user rules" or
on-the-fly created system specific ones, like persistent net names and
cdrom rules. In an ideal setup you would be able to do rm -rf
/etc/udev/rules.d/*, reboot, and start device configuration from
scratch.

Debian didn't catch up the last months, they use an older version of
udev, and have always had thier very own idea of rules, that didn't
match the udev default.

> Is there anywhere else I should get 'make install' to check?

No, just put any udev rule in /lib/udev/rules.d/.

> Debian doesn't get 'mdp' devices right.
> openSUSE is already ready for 2.6.28 in which all md devices can be
> partitions!
>
>>
>> >    I'm contemplating creating a link based on the metadata type with
>> >    a sequential number. e.g. /dev/md/ddf1 or /dev/md/imsm2.
>> >    I'm not sure if there should be in /dev/md/ or directly in /dev/.
>> >    I'm also not sure if I should leave the creation to udev, and
>> >    whether I should use a small sequential number, or just whatever
>> >    number was allocated as the minor number of the device.
>>
>> There is intentionally no support for enumeration in udev, it will
>> just not work and such numbers/links are not reproducible in hotplug
>> environments, and therefore totally useless, and do much more harm
>> than good.
>
> I'm not entirely following your logic here.
> The 'a' 'b' 'c' at the end of e.g. /dev/sda are not reproducible in
> hotplug environments, but they are not totally useless.  I know they
> will remain stable as long as the device is present, so once I found
> out which /dev/sdX is my USB thingo I just plugged in, I can
> repeatedly use that nice simple name to cfdisk, mkfs, mount, whatever
> the device.

Oh, so you need "your enumeration" only to be valid during the
existence of your device? That sounds fine, sure. I read that as you
are thinking about giving devices names which are meaningful across
reboots.

>> Nothing must ever depend on enumeration, or minor numbers, if these
>> properties can not made persistent, attached  to the device itself, so
>> that it will always show up with the same number forever. Better do
>> not even start such an idea, and leave the kernel name as the primary
>> "random" number, instead of creating new randomness on top.
>
> I'm not entirely convinced.  However I can see a real difficulty in
> introducing a new sequence number.  Thus if a 'ddf' array gets created
> as /dev/md15, then if I want to create a name containing the string
> 'ddf', it should be 'ddf15'.  Maybe /dev/ddf15.  Maybe /dev/md/ddf15.

Seems like a misunderstanding, if you need these names only during the
uptime of the device and will not need to remember that name at the
next boot, it's fine sure.

>> >  4/ When we stop an array, mdadm will remove anything from /dev that
>> >    it probably created.
>>
>> Sure, but only if mdadm has it created.
>
> Why would it matter?

Because you are not supposed to remove stuff udev has created. It will
likely create dangling symlinks at least. Also udev maintains a stack
of symlink names, for devices which claim the same symlink name, like
it happens for label and uuid links. If the device goes away, the
device with the next highest priority gets its symlink restored.
Messing around in udev-managed device files will just asks for
trouble.

> Hmmm... Does udev ever deleting things from /dev?

Sure, try with your USB stick, or any other device.

> I notice that 'md'
> devices don't seem to disappear.  Maybe that is because /sys/block/mdX
> never disappears (last time I tried it was too racy).

It stays because the md kernel device lifetime rules are kind of
broken regarding hotplug setups. Similar issue why md needs all the
static nodes in /dev too to create a device.

> Would there be any way to get udev to delete devices when
>  /sys/block/mdX/md/array_state
> becomes 'clear' (presumably on a CHANGE event) ??

What would be the reason to leave the kernel block device around?
Can't you just remove it like any other subsytem in the kernel does.
That would just remove the node, all links and update userspace to
reflect the change.

There is currently no "change" event that could tell to remove a
device node in /dev while we still have a kernel device around. And
you would need to convince me that this is really needed, and why md
is so special here. :)

>> >    In particular, it will remove the device node as described in 1,
>> >    any partitions, and any symlinks in /dev or /dev/md which point to
>> >    any of those.  I need to be certain that this won't confuse udev.
>>
>> You must never touch anything that udev has created. It must be driven
>> by kernel "add/remove/change" events.
>
> Again - why?  I notice that if I do remove the device nodes when the
> array is stopped, the still create nicely recreated when I restart the
> array.
> However I seem to have decided to make a clear distinction between
> when udev is running or now, so I'll not remove anything if I think
> udev is running.

As said, I think the block device in the kernel should go, if md wants
to inetgrate without special casing in the usual hotplug setup. /dev
is just the mirror of kernel devices, not to hide stuff from users
which exists in the kernel. :)

>> > I'm also wondering if I should include a udev 'rules' file for md in
>> > the mdadm distribution.  Obviously it would be no more than a
>> > recommendation, but it might give me a voice in guiding how udev
>> > interacted with mdadm.
>>
>> Definitely, it should carry a udev rules file which instructs udev to
>> create all intended symlinks and also supports the raid auto-assembly
>> setup. It should not mount anything by default though.
>
> But why is 'mounting' so much different to 'assembling' in people's
> eyes?   Certainly mounting readonly should be OK if assembling is
> seen as OK.
>
> However I have no intention of automounting anything.

I guess mounting makes stuff visible and makes data vulnerable, and is
definitely more a "policy decision" at the userspace level than an
array assembly. The question alone where to mount, it is not easy to
answer, and definitely a more difficult policy than to create a simple
block device.

>> I'm happy, to see you working on next-generation mdadm. I like to see
>> a better integration with udev, and especially, if mdadm detects a
>> running udev, not to mess around in /dev in any way, but leave the
>> names in /dev to instructions in udev rules. Temporary nodes are fine,
>> as long as they don't conflict with anything else, and get removed
>> after they are not needed anymore. All updates to symlinks and such
>> should be done by "change" events from the kernel, which instructs
>> udev to update all the links, and not by touching anything in /dev
>> from mdadm.
>
> Better late than never :-)
>
> I asked it in another email, but for completeness:
>  What is the best way to detect in udev is running?  And will it
>  work the same in all distros (having discovered the /lib/udev vs
>  /etc/udev difference, I'm a little worried).

All recent udev versions support /lib/udev/rules.d/ and
/etc/udev/rules.d/. And non-user tweakable stuff should not be in
/etc. I wouldn't care too much in your source package. Packagers with
special requirements will care about non-default setups in their
package.

>> Do you think mdadm will stay a program only, called by udev/the user,
>> or will a port of its functionality live in a daemon?
>
> What are you thinking here?
>
>  mdadm --monitor runs as a daemon, emails interesting events, and
>  sometimes moves spares between arrays.
>
>  mdmon (a new program in mdadm-3.0) is a daemon that monitors a
>  particular array (or more accurately, a set of related metadata,
>  there might be several arrays) and updates the metadata
>  accordingly.  This isn't used for v0.90 of v1.x metadata.
>
>  mdadm -D and mdadm -E can be run from udev to help with hot plug
>  events.
>
> These are all daemons or daemon-like functionality.  What else were
> you thinking of?  A stand-alone daemon that supports HTTP and allows
> arrays to be built and configured from a browser?  No.  I wouldn't
> do that. ;-)

I was just checking possibililites for mdadm to watch for events from
udev, which wouldn't work with a invoked program, because it would
permanently need to listen to a socket. No special idea or plan here,
just checking what you have in mind.

Kay
