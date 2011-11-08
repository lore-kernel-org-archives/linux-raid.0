From: Michal Soltys <soltys@ziu.info>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Tue, 08 Nov 2011 01:11:53 +0100
Message-ID: <4EB873C9.5020900@ziu.info>
References: <20110208094843.GD11446@tango.0pointer.de> <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com> <20110208110730.GF23157@tango.0pointer.de> <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com> <20110208172822.GC21847@tango.0pointer.de> <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com> <20111031110613.GA1402@tango.0pointer.de> <20111102114416.7879b77f@notabene.brown> <20111102011615.GA5289@tango.0pointer.de> <20111102130334.09c3ab51@notabene.brown> <20111102133223.GC5119@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102133223.GC5119@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: NeilBrown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11-11-02 14:32, Lennart Poettering wrote:
> What we do right now is this:
>
> kill_all_processes();
> do {
>       umount_all_file_systems_we_can();
>       read_only_mount_all_remaining_file_systems();
> } while (we_had_some_success_with_that());
> jump_into_initrd();
>
> As long as mdmon references a file from the root disk we cannot umount
> it, so the loop wouldn't be effective.
>

I've peeked into systemd, and from what I can see, it /only/ jumps back 
to initramfs (prepare_new_root() and pivot_to_new_root()) if shutdown 
"binary" is present on initramfs. And whenever mdmon is still running or 
not, is not in any way determinent for pivot_root(2) call to succeed (or 
... ?).

If /run/initramfs/shutdown is not present, then systemd just do the 
things the old way as far as I can see - it doesn't even attempt to 
pivot. And if it doesn't, the it can't umount the root (being itself 
tied to it) ?

So essentially, if systemd execs /shutdown (after pivoting to 
/run/initramfs) - then it's dracut's modules.d/99shutdown, which itself 
sources hooks from other modules to do the rest of cleaning job. And 
that should take care of all the remaining stuff (including terminating 
mdmon in graceful way, and then umounting /oldroot). Either way - pretty 
simple to add the necessary functionality to dracut.

So wouldn't simply a systemd's cgroup named say - immortals - with mdmon 
(by default) in it suffice ? Pivot back as usual, leave mdmon alive, let 
the dracut (or anything else used for initramfs) do the rest of the job 
(properly).


p.s.
Sorry if I missed something obvious, it was a quick and late peek over 
systemd's shutdown.c.
