From: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: let md auto-detect 128+ raid members, fix potential race condition
Date: Tue, 01 Aug 2006 18:32:33 -0300
Message-ID: <orlkq8f8ge.fsf@free.oliva.athome.lsd.ic.unicamp.br>
References: <ork65veg2y.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<20060730124139.45861b47.akpm@osdl.org>
	<orac6qerr4.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<17613.16090.470524.736889@cse.unsw.edu.au> <44CF9221.90902@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44CF9221.90902@tmr.com> (Bill Davidsen's message of "Tue, 01 Aug 2006 13:40:49 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Aug  1, 2006, Bill Davidsen <davidsen@tmr.com> wrote:

> I rarely think you are totally wrong about anything RAID, but I do
> believe you have missed the point of autodetect. It is intended to
> work as it does now, building the array without depending on some user
> level functionality.

Well, it clearly depends on at least some user level functionality
(the ioctl that triggers autodetect).  Going from that to a
full-fledged mdadm doesn't sound like such a big deal to me.

> I don't personally see the value of autodetect for putting together
> the huge number of drives people configure. I see this as a way to
> improve boot reliability, if someone needs 64 drives for root and
> boot, they need to read a few essays on filesystem
> configuration. However, I'm aware that there are some really bizarre
> special cases out there.

There's LVM.  If you have to keep root out of the VG just because
people say so, you lose lots of benefits from LVM, such as being able
to grow root with the system running, take snapshots of root, etc.

Sure enough the LVM subsystem could make things better for one to not
need all of the PVs in the root-containing VG in order to be able to
mount root read-write, or at all, but if you think about it, if initrd
is set up such that you only bring up the devices that hold the actual
root device within the VG and then you change that, say by taking a
snapshot of root, moving it around, growing it, etc, you'd be better
off if you could still boot.  So you do want all of the VG members to
be around, just in case.

This is trivially-accomplished for regular disks whose drivers are
loaded by initrd, but for raid devices, you need to tentatively bring
up every raid member you can, just in case some piece of root is
there, otherwise you may end up unable to boot.

Yes, this is an argument against root on LVM, but there are arguments
*for* root on LVM as well, and there's no reason to not support both
behaviors equally well and let people figure out what works best for
them.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Secretary for FSF Latin America        http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
