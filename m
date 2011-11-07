From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Mon, 7 Nov 2011 11:09:19 -0800
Message-ID: <CABE8wwug4-gMLA4rd6FXgV3db2XiwUcfsXp6fC=NipKg333n-g@mail.gmail.com>
References: <20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<20111107135241.64ae261d@notabene.brown>
	<20111107120048.GD25130@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111107120048.GD25130@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: NeilBrown <neilb@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 7, 2011 at 4:00 AM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Mon, 07.11.11 13:52, NeilBrown (neilb@suse.de) wrote:
>
>> > Why doesn't the kernel do that on its own?
>>
>> Because the kernel doesn't know about the format of the metadata tha=
t
>> describes the array.
>
> Yupp, my suggestion would be to change that.

It's quite a bit of idiosyncratic code that needs to be duplicated in
kernel space and userspace (since userspace always needs to know how
to parse the metadata for array assembly).  All to record a dirty bit
that flips at most every 5 seconds, or a disk failure event which is
even less frequent.  Throw in policy constraints like restricting
which block devices can become part of the raid set.  Rinse and repeat
for every possible metadata format.

[..]
>> What exactly is "kill_all_processes()"? =A0 is it SIGTERM or SIGKILL=
 or both
>> with a gap or ???
>
> SIGTERM followed by SIGKILL after 5s if the programs do not react to
> that in time. But note that this logic only applies to processes whic=
h
> for some reason managed to escape systemd's usual cgroup-based killin=
g
> logic. Normal services are hence already killed at that time, and onl=
y
> processes which moved themselves out of any cgroup or for which the
> service files disabled killing might survive to this point.

So I think mdmon should always try to escape itself from cgroup based
killing.  It follows the lifespan of the array, and if the array is
not stopped by the cgroup exit (or the array lifespan is not
controlled in a service file), then mdmon must keep running.

[..]
>
> Here's another attempt in explaining how this works:
>
> <snip>
> terminate_all_mount_and_service_units();
> kill_all_remaining_processes();
> do {
> =A0 =A0 umount_all_remaining_file_systems_we_can();
> =A0 =A0 read_only_mount_all_remaining_file_systems();
> =A0 =A0 detach_all_remaining_loop_devices();
> =A0 =A0 detach_all_remaining_swap_devices();
> =A0 =A0 detach_all_remaining_dm_devices();

So I've started putting together a md_detach_all() routine that will
attempt to stop all md devices (via sysfs).  Where all mdmon instances
have missed the initial killall with the argv '@' flagging.

Like the dm implementation it will address all but the root md device.

> } while (we_had_some_success_with_that());
> jump_into_initrd();

The final act of the initramfs is then "mdadm --wait-clean --scan" to
communicate with the rootfs-blockdev-mdmon to be sure the metadata has
been marked clean.  All other mdmon instances should have exited
naturally when their md devices stopped, but the "--wait-clean --scan"
will have ensured shutdown can progress safely.

> You have relatively flexible control of the first step in this code. =
The
> second step is then the hammer that tries to fix up what this step
> didn't accomplish. My suggestion to check argv[0][0] was to avoid the
> hammer.

I notice that if the rootfs is on a dm or md device systemd/shutdown
will always fall through to ultimate_send_signal() which will not
discriminate against processes flagged with '@'.  Since we aren't
stopping the root md device I wonder if ultimate_send_signal() should
also ignore flagged processes, or whether the failure to stop the root
device is to be expected and let shutdown skip ultimate_send_signal()
if the only remaining work is shutting down the rootfs-blockdev.  I'm
leaning towards the latter.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
