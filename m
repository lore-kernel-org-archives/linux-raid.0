From: Neil Brown <neilb@suse.de>
Subject: Re: behavior different from mdadm 2.6.4 and 3.0?
Date: Tue, 16 Dec 2008 12:27:39 +1100
Message-ID: <18759.1035.627538.450310@notabene.brown>
References: <cccedfc60812150654u2e841bf8na517a75820d0c463@mail.gmail.com>
	<18758.51222.370545.686154@notabene.brown>
	<cccedfc60812151335u3d08dc6bid79bae8c88a62133@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> On Mon, Dec 15, 2008 at 3:11 PM, Neil Brown <neilb@suse.de> wrote:
> > On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> >> mdadm --incremental seems to behave differently for me between mdadm
> >> 2.6.4 and 3.0
> >>
> >> With 2.6.4, mdadm --incremental /dev/nbd0 does this:
> >>
> >> mdadm: /dev/nbd0 attached to /dev/md10 which is already active.
> >>
> >> With 3.0, it does this:
> >>
> >> mdadm: /dev/md10 is already in use.
> >>
> >> and does *not* add it to the array.
> >
> > Sounds like /var/run/mdadm/map is not correctly up-to-date.
> > Does running
> >   mdadm -Ir
> >
> > make "mdadm -I /dev/nbd0" work properly again?
> >
> > Can you provide a sequence of steps which leads to the error message
> > that you report?
> 
> I have to reboot to make this happen. There is probably a less
> invasive way.... but it's what I know works.
> 
> First, an strace of mdadm --incremental (3.0):
> 
> turnip:~ # strace -f -e trace=open mdadm --incremental /dev/nbd0
> open("/etc/ld.so.cache", O_RDONLY)      = 3
> open("/lib64/libc.so.6", O_RDONLY)      = 3
> open("/dev/urandom", O_RDONLY)          = 3
> open("/etc/mdadm.conf", O_RDONLY)       = 3
> open("/dev/nbd0", O_RDONLY|O_EXCL|O_DIRECT) = 3
> open("/var/run/mdadm/map.lock", O_RDWR|O_CREAT, 0600) = 3
> open("/var/run/mdadm/map", O_RDONLY)    = -1 ENOENT (No such file or directory)
> open("/var/run/mdadm.map", O_RDONLY)    = -1 ENOENT (No such file or directory)

That's the problem then.
The array was started from initrd and any mdadm/map that was created
would have got lost.
Now it needs one to continue with assembly and cannot find one.
I'll have to get it to do the "-Ir" thing automagically if mdadm/map
does not exist.

> open("/var/run/mdadm/map", O_RDONLY)    = -1 ENOENT (No such file or directory)
> open("/var/run/mdadm.map", O_RDONLY)    = -1 ENOENT (No such file or directory)
> open("/proc/mdstat", O_RDONLY)          = 4
> mdadm: /dev/md11 is already in use.
> turnip:~ #
> 
> 
> Running (again, v3.0) mdadm --incremental --rebuild-map works rebuilds the map.
> 
> Then using --incremental /dev/nbd0 works (but it's resyncing **again**).
> 
> Does that help?

So: yes it does - thanks.

I've got some coding to do ;-)

NeilBrown
