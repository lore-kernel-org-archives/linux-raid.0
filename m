From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: "failed" vs "released" and "locked-out" state and --incremental auto-re-adding
Date: Tue, 27 Apr 2010 10:13:00 +0000 (UTC)
Message-ID: <loom.20100427T113838-836@post.gmane.org>
References: <loom.20100423T140059-877@post.gmane.org> <loom.20100427T002749-963@post.gmane.org> <4BD61EA7.5060609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks you for responding and adding insight.

Doug Ledford <dledford <at> redhat.com> writes:
> On 04/26/2010 06:28 PM, Christian Gatzemeier wrote:
> > 2) To "unbind", "unlist" or "dismiss" a member from the md device s=
tats is
> > currently called to --remove it. In particular you can "unbind", "u=
nlist"
> > or "dismiss" failed or detatched members with --remove failed/detac=
hed.
>=20
> You can use --remove failed/detached/=E2=89=A4devname>, they all work=
=2E  But yes,
> the underlying action here is to take an already failed device go ahe=
ad
> and release

There we have a very good word to name --remove so that mdadm is easier=
 to
understand (IMHO). "release"



> > 3) A safe way to "lock-out" or "really remove" members from
> > udev/--incremental assembly is not available yet AFAIK.
> > (--zero-superblock on mirror members makes the md device content
> >  detectable/available directly)
>=20
> This is a shortcoming of version 0.90/1.0 superblocks and raid1 array=
s.
>  For all other superblock versions and raid types, this is not true.
> The default superblock version changed from 0.90 to 1.2 as of the mda=
dm
> 3.1 series and so this won't be a problem in the future.

Good, that'll fix the problem with --zero-superblock for the future.

An explicit "locked-out" state without killing the superblock may still=
 be
good. (Even if only for pausing or optionally auto-locking out detected
alternative versions.)



=20
> > IMHO the ones mentioned first could seen as implied by those mentio=
ned
> > later.
>=20
> No, and this is a safety feature.  We won't remove a good device in
> order to prevent a typo from rendering an array dead.

I understand, makes sense to me.
Ok, if mdadm --remove (release) could give a little hint to --fail firs=
t, if
"device is busy", it may be able save some head scratches. ;)



> > I am unclear why --incremental seems to require a device to be
> >  --removed (released) first
>
> It would be kind of useless to put that support into incremental.
> Incremental isn't really intended to be run from the command line
> (although you can), it's intended to be done on hotplug events.

That is exactly were I encountered this. Unplugging a failed disk, and
plugging it back in again would fail, unless I manually --remove (relea=
sed)
the device before plugging it back in.

But I think the hot-unplugging support you added will probably fix this=
 in
the future even nicer. (Automatically releasing devices as soon as they=
 are
detached.)



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
