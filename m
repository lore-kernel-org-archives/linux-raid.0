From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: mdraid autodetect partially failing after disk replacement
Date: Thu, 09 May 2013 23:52:19 -0600
Message-ID: <1368165139.4029.41.camel@linux-lxtg.site>
References: <8tj2wq0eu1swie7m884u2d8i.1368161579257@email.android.com>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8tj2wq0eu1swie7m884u2d8i.1368161579257@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ricky Burgin <ricky@burg.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ricky,

When talking about things that happen before the root device is mounted
you are talking about the initial ramdisk. =20

I'm not sure on the specifics for what you're running but can we presum=
e
that this is the root filesystem?  If it is we can deduce that an mdadm
binary, mdadm.conf file and some udev rules to assemble the array need
to exist in the initrd/initramfs.  There may also be a script that
directly executes an mdadm incremental or assemble command.  If the
array isn't being properly started then there could be a problem
detecting the disks (driver issue), the mdadm.conf in the ramdisk could
be incorrect (a devices line excluding the disks or something) or for
some reason the udev rule or mdadm command isn't firing.  None of those
seem likely given the sequence of events you talked about in your first
thread on this problem, but we have to focus on what this system is
doing at boot that your rescue environment isn't.

If your system uses dracut then you can use rdshell to poke around at
what is happening when the root filesystem fails to mount.  You can loo=
k
at the device nodes that are created, run commands like blkid, and use
mdadm to attempt assembling the array, for instance.  If you manage to
get it assembled you can type 'exit' to continue booting.  This exercis=
e
could possibly shed some light on your problem - helping you understand
what specifically is amiss in your pre-root environment that isn't wron=
g
when booting another OS (and ramdisk).

Wish I could be more specific, but hopefully this gets you something
more to look at.  I think this is what Neil was hinting at when he
suggested that you might need to create a new initrd - which is what yo=
u
would probably end up doing to fix this anyway if you found something
wrong in your initial ramdisk.

Hope this helps,

Tregaron

On Fri, 2013-05-10 at 05:52 +0100, Ricky Burgin wrote:
> Hi Sam,
>=20
> Thanks for the response. Unfortunately that's not the case, that was =
one of the first things I checked. What variables are considered when a=
dding or excluding drives to or from a raid via autodetection? This pro=
blem feels so esoteric that it might just be a bug...=20
>=20
> I'll keep on trying!
>=20
> Ricky
>=20
> Sam Bingner <sam@bingner.com> wrote:
>=20
> >On May 8, 2013, at 3:20 PM, Ricky Burgin <ricky@burg.in> wrote:
> >
> >> Hello again,
> >>=20
> >> Little bit of progress since I last dropped a message in (sorry fo=
r the
> >> duplicate, didn't think the initial one got through).
> >>=20
> >> The kernel has mdraid built into it and all disks are using 0.90
> >> superblocks, all 'fd' partitions, but only 2 or 4 disks are being
> >> recognised and applied to the freshly created raid array which wor=
ks
> >> fine when mounted on any other OS.
> >>=20
> >> Any suggestions for what could cause disks to be overlooked by mdr=
aid
> >> before the root device is even attempted to be mounted would be ve=
ry
> >> helpful, I'm now totally at a loss as to what to do from here.
> >>=20
> >> Kind regards,
> >> Ricky Burgin
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >Is it possible that you still have 1.x superblocks on two drives tha=
t are being detected before the 0.9 superblocks on this OS?  I don't kn=
ow if this is or is not possible, but that is the only strangeness I se=
e from your prior posts etc.
> >
> >You should probably boot that version of CentOS's rescue mode and se=
e if you have the same issues there...=20
> >
> >SamNrybX=C7=A7v^)=DE=BA{.n+{{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwjm=
=07zZ+=DD=A2j"!


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
