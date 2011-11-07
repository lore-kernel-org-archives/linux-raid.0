From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
    by user
Date: Mon, 7 Nov 2011 13:00:49 +0100
Message-ID: <20111107120048.GD25130@tango.0pointer.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111107135241.64ae261d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 07.11.11 13:52, NeilBrown (neilb@suse.de) wrote:

> > Why doesn't the kernel do that on its own?
> 
> Because the kernel doesn't know about the format of the metadata that
> describes the array.

Yupp, my suggestion would be to change that. 

> > What we do right now is this:
> > 
> > kill_all_processes();
> > do {
> >      umount_all_file_systems_we_can();
> >      read_only_mount_all_remaining_file_systems();
> > } while (we_had_some_success_with_that());
> > jump_into_initrd();
> > 
> > As long as mdmon references a file from the root disk we cannot umount
> > it, so the loop wouldn't be effective.
> 
> What exactly is "kill_all_processes()"?   is it SIGTERM or SIGKILL or both
> with a gap or ???

SIGTERM followed by SIGKILL after 5s if the programs do not react to
that in time. But note that this logic only applies to processes which
for some reason managed to escape systemd's usual cgroup-based killing
logic. Normal services are hence already killed at that time, and only
processes which moved themselves out of any cgroup or for which the
service files disabled killing might survive to this point.

> I assume a SIGKILL.  I don't mind a SIGTERM and it could be useful to
> expedite mdmon cleaning up.
> 
> However there is an important piece missing.  When you remount,ro a
> filesystem, the block device doesn't get told so it thinks it is still open
> read/write.  So md cannot tell mdmon that the array is now read-only
> It would make a lot of sense for mdmon to exit after receiving a SIGTERM as
> soon as the device is marked read-only.  But it just doesn't know.

As mentioned by Kay, you can get notifications for this by poll()ing on
/proc/self/mountinfo. Note again however, that we kill first, and only
then try to unmount/remount.

> We can probably fix that, but that doesn't really help for now.
> 
> I think I would like:
> 
>  - add to the above loop "stop any virtual devices that we can".
>    Exactly how to do that if /proc and /sys are already unmounted
>    is unclear.  Is one or both of these kept around somewhere?

/proc and /sys are not unmounted in this loop. Being virtual API fs we
exclude them from this logic and leave them around until the initrd
unmounts them if it wants to.

Actually, in the loop above there are three more steps: in each
iteration we also try to detach all swap devices, all loopback devices
and all DM devices. We probably could add a similar operation for MD
devices here too. But note that this loop is more of a last-resort
thing, and normally shouldn't do much.

>  - allow processes to be marked some way so they get SIGTERM but not
>    SIGKILL.  I'm happy adding magic char to argv[0].

Note that you can configure how you are killed relatively flexibly in
the service files and that the loop pointed out above is only this last
resort thing which is applied to all processes/mount points/... which
stick around after this normal shutdown.

Here's another attempt in explaining how this works:

<snip>
terminate_all_mount_and_service_units();
kill_all_remaining_processes();
do {
     umount_all_remaining_file_systems_we_can();
     read_only_mount_all_remaining_file_systems();
     detach_all_remaining_loop_devices();
     detach_all_remaining_swap_devices();
     detach_all_remaining_dm_devices();
} while (we_had_some_success_with_that());
jump_into_initrd();
</snip>

You have relatively flexible control of the first step in this code. The
second step is then the hammer that tries to fix up what this step
didn't accomplish. My suggestion to check argv[0][0] was to avoid the
hammer.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
