From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: systemd kills mdmon if it was started manually
	by user
Date: Tue, 8 Feb 2011 13:52:41 +0300
Message-ID: <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
	<201012041012.23757.trapni@gentoo.org>
	<AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
	<20101204121413.GC11336@mother.pipebreaker.pl>
	<AANLkTi=nTSdHc55f08G9sdEK6u8eXp276VOTHHr0jmXT@mail.gmail.com>
	<20110125034434.GC7046@tango.0pointer.de>
	<AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
	<20110125042814.GA9727@tango.0pointer.de>
	<AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
	<20110208094843.GD11446@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org>
In-Reply-To: <20110208094843.GD11446@tango.0pointer.de>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
Errors-To: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-raid@vger.kernel.org, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Tue, Feb 8, 2011 at 12:48 PM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Fri, 04.02.11 22:55, Andrey Borzenkov (arvidjaar@mail.ru) wrote:
>
>> >> That's right, but the names are not known in advance and can change
>> >> between reboots. This means such units have to be generated
>> >> dynamically, exist until reboot (ramfs?) and be removed when array is
>> >> destroyed. Not sure it is really manageable.
>> >
>> > Hmm? It should be sufficient to just write the service template properly
>> > ("mdmon@.service") and then instantiate it when needed with "systemctl
>> > start mdmon@xyz.service" or something equivalent. itMs a matter of
>> > issuing a single dbus call.
>> >
>> >> And which instance should generate them? mdadm?
>> >
>> > i think it is much nicer to spawn the necessary mdadm service instance
>> > from a udev rule,
>>
>> Yes, this can be done relatively easily; as proof of concept:
>>
>> SUBSYSTEM!="block", GOTO="systemd_md_end"
>> ACTION!="change", GOTO="systemd_md_end"
>> KERNEL!="md*", GOTO="systemd_md_end"
>> ATTR{md/metadata_version}=="external:[A-Za-z]*", RUN+="/bin/systemctl
>> start mdmon@%k.service"
>> LABEL="systemd_md_end"
>
> Nah, it's much better to simply use the SYSTEMD_WANTS var on the device.
>
> Something like this:
>
> ...., ENV{SYSTEMD_WANTS}="mdmon@%k.service"
>
> That way the device unit will simply have a wants dep on the service
> unit, and this is prefectly discoverable.
>
>> Setting SYSTEMD_WANTS would be more elegant solution, but it does not
>> work with current systemd implementation. It is capable of starting
>> requested units only on "add" event (effectively the very first time
>> device becomes plugged), while mdmon must be started on "change"
>> event, as only then we know whether mdmon is required at all.
>
> Oha, so you are actually aware of SYSTEMD_WANTS. Hmm. I need to think
> about this. Why does md employ the change event? Is this really
> necessary, smells a bit foul.
>

I am probably the wrong one to ask, but here is what happens when
array is started (from udev perspective)

UDEV  [1297507039.109828] add      /devices/virtual/block/md127 (block)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/virtual/block/md127
SUBSYSTEM=block
DEVNAME=/dev/md127
DEVTYPE=disk
SEQNUM=1742
UDISKS_PRESENTATION_NOPOLICY=1
MAJOR=9
MINOR=127
TAGS=:systemd:

After this event device goes "plugged" and SYSTEMD_WANTS (if any) are
triggered. But at this point we have zero information about array to
decide anything.

UDEV  [1297507039.211940] change   /devices/virtual/block/md127 (block)
UDEV_LOG=3
ACTION=change
DEVPATH=/devices/virtual/block/md127
SUBSYSTEM=block
DEVNAME=/dev/md127
DEVTYPE=disk
SEQNUM=1743
MD_LEVEL=container
MD_DEVICES=2
MD_METADATA=ddf
MD_UUID=f8362f39:0436b20f:cf338104:afec436e
MD_DEVNAME=ddf0
UDISKS_PRESENTATION_NOPOLICY=1
MAJOR=9
MINOR=127
DEVLINKS=/dev/disk/by-id/md-uuid-f8362f39:0436b20f:cf338104:afec436e
/dev/md/ddf0
TAGS=:systemd:

At this point we know it is container, know that it has external
metadata and know that we need external metadata handler (mdmon). But
it is too late for systemd.

>
>> Actually it can be implemented even without mdadm patches; apparently
>> it is possible to suppress normal starting of mdmon by setting
>> MDADM_NO_MDMON=1
>
> A this point mdmon is simply broken: if glibc or mdmon itself (or any
> lib it is using) is upgraded, then mdmon will keep referencing the old
> .so or binary as long as it is running. This means that the fs these
> files are on cannot be remounted r/o. However mdmon insists on being
> shutdown only after all fs got remounted ro. So you have a cyclic
> ordering loop here: mdmon wants to be shut down after the remount, but
> we need to shut it down before the remount.
>

Ehh ...

a) mdmon is perfectly capable of restarting, it is already used to
take over mdmon launched in initrd. The problem is to know when to
restart - i.e. when respective libraries are changed. This is a job
for package management in distribution. It is already employed for
glibc, systemd and some others and can just as well be employed for
mdmon. And this is totally unrelated to systemd :)

b) having binary launched off some fs should not prevent this fs to be
remountd ro - binaries are not opened rw

> This is unfixable unless a) mdmon learns reexecution of itself without
> losing state (like most init systems so), or b) mdmon would stop
> insisting on being shutdown only after the remount.
>

As far as I can tell, both is true today; but remounting is not
enough, unfortunately.

> In my eyes b) is very much preferebale: It should be possible to shut
> down mdmon like any other service. And if then some md related code
> still needs to be run on late shutdown this should be done from a new
> process. I would be willing to add some hooks for this, so that we can
> execute arbitrary drop-in processes as part of the final shutdown loop.
>

mdmon is needed to ensure metadata were correctly updated. So it needs
to exist as long as metadata *may* be updated. For practical purposes
it means - until file system is unmounted and flushed to disks. I am
not sure that remounting ro stops all activity (at least, mounting ro
definitely *writes* to device using some filesystems).
