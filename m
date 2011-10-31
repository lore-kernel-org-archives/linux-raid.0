From: Lennart Poettering <lennart@poettering.net>
Subject: Re: systemd kills mdmon if it was started manually
 by user
Date: Mon, 31 Oct 2011 12:06:13 +0100
Message-ID: <20111031110613.GA1402@tango.0pointer.de>
References: <20110125034434.GC7046@tango.0pointer.de>
	<AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
	<20110125042814.GA9727@tango.0pointer.de>
	<AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
	<20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
Errors-To: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Sun, 23.10.11 01:00, Dan Williams (dan.j.williams@intel.com) wrote:

> > Well, it would be nice if the md utils would offer something doing this
> > without spawning multiple processes and killing them again.
> >
> 
> /me wonders why his raid5 resyncs every boot on Fedora 15 and has
> found this old thread.
> 
> I'm tempted to:
> 
> 1/ teach ignore_proc() to scan for pid files in /dev/md/ (MDMON_DIR on
> Fedora)

This will not help you.

We nowadays jump back into the initrd when we shut down, so that the
initrd disassembles everything it assembled at boot time. This for the
first time enables us to ensure that all layers of our stack are in a
sane state (i.e. fully offline) when we shut down, regardless in which
way you stack it.

However, just excluding mdmom from being killed will not make this work,
simply because jumping into initrd only works sensibly if we can drop
all references to all previous mounts which requires us to have only one
process running at that time, and one process only.

It always boils down to the same thing: mdmon must be something we can
shutdown cleanly like every other process. Excluding it from that will
just move the problem around, but not fix it.

> 2/ arrange for mdadm --wait-clean --scan to be called after all
> filesytems have been mounted read only

Won't help you really either, since we have to kill all processes before
we jump into the initrd to fully disassemble mounts and storage.

There'll always be this chicken and egg problem: we cannot disassmble
all storage until all processes are gone and we are back in the
initrd. But mdmon wants to stay running after we 

> ...but a few things strike me.  This does not seem to be what was
> being proposed above.  Systemd does not treat dm devices like a
> service and takes care to shut them down explicitly (but in that case
> there is an api that it can call).  Is it time for a libmd.so,  so
> systemd can invoke the "--wait-clean --scan" process itself?  Probably
> simpler to just SIGTERM mdmon and wait for it.

We actually try to disassemble md already, i.e. we call the
DM_DEV_REMOVE ioctl for all left-over devices. I am not really
interested to link against libdm itself.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
