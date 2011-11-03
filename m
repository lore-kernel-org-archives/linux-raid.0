From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Wed, 2 Nov 2011 17:28:50 -0700
Message-ID: <CABE8wwv-TO4EpuokwZD_Ayyez=asmy9aPw6LoyL1BY6GKU92og@mail.gmail.com>
References: <20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
	<20111102151749.GE5119@tango.0pointer.de>
	<CAPXgP13XEsGSdrftU77-ee3k0gE=O=Odrb4YNkADUFCJ352ZBg@mail.gmail.com>
	<20111102152913.GG5119@tango.0pointer.de>
	<CABE8wwvKJzPUqy20-B+X-8QdKqK8X_r0yueegUVDeXsVZjQjSA@mail.gmail.com>
	<20111102233900.GC20729@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102233900.GC20729@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, Nov 2, 2011 at 4:39 PM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Wed, 02.11.11 15:18, Williams, Dan J (dan.j.williams@intel.com) wr=
ote:
>
>>
>> On Wed, Nov 2, 2011 at 8:29 AM, Lennart Poettering
>> <lennart@poettering.net> wrote:
>> > On Wed, 02.11.11 16:21, Kay Sievers (kay.sievers@vrfy.org) wrote:
>> >
>> >>
>> >> On Wed, Nov 2, 2011 at 16:17, Lennart Poettering <lennart@poetter=
ing.net> wrote:
>> >> > Kernel threads we detect by checking whether /proc/$PID/cmdline=
 is
>> >> > empty, hence I'd suggest we use the first char of argv[0][0] he=
re, to
>> >> > detect whether something is a process to avoid killing. Questio=
n is
>> >> > which char to choose for that. I am tempted to use '@'.
>> >>
>> >> Maybe introduce a 'initramfs' cgroup and move the pids there?
>> >
>> > Well, in which hierarchy? I am a bit concerned about having other
>> > subsystems muck with the systemd cgroup hierarchy, before systemd =
has
>> > set it up.
>> >
>> > I can see some elegance in having all code from the initrd that re=
mains
>> > running during boot in a cgroup of its own, but that's probably
>> > orthogonal to finding a way to recognize processes not to kill at
>> > shutdown. Why? Because there's stuff like Plymouth which also stay=
s
>> > around from the initramfs, but actually is something we *do* want =
to
>> > kill on shutdown.
>>
>> So how about rather than binaries self modifying themselves as "plea=
se
>> don't kill me" with argv[][], shutdown can just avoid process where
>> /proc/$PID/cmdline starts with /run/initramfs? =A0Then it's up to =A0=
where
>> the initramfs runs the binary to determine which instances it wants
>> provenance over versus leaving to the init system.
>
> Nope, whether something should be excluded of killing during shutdown=
 is
> orthogonal to being part of the initramfs. For example, Plymouth
> (i.e. the graphical boot splash thingy) is started form initrd too, b=
ut
> we definitely want to kill it on shut down.

In the plymouth case the path would be /bin/plymouth, the initramfs
would need to take special care to run mdmon from /run/initramfs to
identify it as needing the initramfs environment to carry out its
shutdown.

> I am a bit concerned about checks against paths since initrd might pl=
ay
> some namespacing games and the paths might not appear to the main sys=
tem
> they way you'd expect.

The initramfs needs to be modified to either tell mdmon it is running
from the initramfs or arrange for /proc/$MDMON_PID/cwd to appear to be
from /run/initramfs.  I only like the latter because it works with
existing mdmon binaries, but we may need shutdown to always leave
mdmon alone...

=46or user started md arrays the shutdown sequence still goes:

killall --> umount

=2E..and we would need to express::

killall (but mdmon) --> umount --> mdadm -Ss (stops all not in use arra=
ys)

So maybe we do the argv "@" tagging in all cases and systemd never
kills mdmon but arranges for all (stoppable) md devices to be stopped,
then rely on /run/initramfs/shutdown to handle the rootfs blockdev.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
