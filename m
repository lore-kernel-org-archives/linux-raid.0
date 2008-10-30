From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Thu, 30 Oct 2008 13:18:47 -0400
Message-ID: <1225387127.26510.155.camel@firewall.xsintricity.com>
References: <18692.62860.863118.727187@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tQmbLkT/5P3EWUFdc0+v"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18692.62860.863118.727187@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids


--=-tQmbLkT/5P3EWUFdc0+v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 09:56 +1100, Neil Brown wrote:
> Greeting.
>  This is a Request For Comments....

OK, I've taken my time responding to this at least partially because I
wanted to get you my current changes first.

>  Device naming in mdadm is a bit of a mess.
>  We have partitioned devices (mdp) and non-partitioned (md)
>  We have names in /dev/md/ (/dev/md/d0) and directly in /dev
>     (/dev/md_d0).
>  We have support for user-friendly names (/dev/md/home) and for
>     "kernel-internal" names (/dev/md0).
>=20
>  All this can produce extra confusion when udev is brought into the
>  picture.  And it can leave lots of litter lying around in /dev if we
>  aren't careful (which we aren't).
>=20
>  I hope to release mdadm-3.0 this year, and maybe that gives me a
>  chance to get it "right".  I don't want to break backwards
>  compatibility in a big way, but I think I am happy to introduce
>  little changes if it means a more consistent model.
>=20
>  In 2.6.28, partitioned devices (mdp) wont be needed any more as md
>  will make use of the "extended partition" functionality recently
>  added.  All md devices can be partitioned.  The device number for the
>  partitions will be very different to that of the whole device, but
>  udev should hide all of that.  So we don't have to worry too much
>  about mdp devices.

Back compatibility, and the ability to use current mdadm on older
kernels may mean that we need to deal with mdp devices regardless.

>  So I think the following is how I want things to work.  I am very
>  open to comments and suggestions.  Particularly I want to know what
>  (if anything) this will break.
>=20
>  1/ The only device nodes created will be /dev/mdX and /dev/md_dX
>     along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
>     These will be created by mdadm in accordance with the "--auto"
>     flag unless something in mdadm.conf says to leave it to udev.
>     In that case, mdadm will create a temporary node
>     (/dev/.mdadm.whatever) and remove it once udev has created the
>     real thing.

One thing I noticed in my work on the incremental stuff, is that the
user friendly device naming method still wants to create
these /dev/md_dX{pY} array names.  I'm actually in favor of doing away
with the notion that an array needs to be numbered and exist in a
numbered format in the /dev/ namespace.  If you have a user friendly
name, such as /dev/md/root and /dev/md/boot, or /dev/md/root_p1
and /dev/md/root_p2, I see no need to add additional numbered devices.
Instead, just allow the device number of the named devices to be random.

>  2/ There will be various symlinks to these devices.
>     a/ if "symlinks=3Dyes" is given in mdadm.conf, symlinks from
>          /dev/md/X or /dev/md/dX will be created.
>     b/ if udev is configured like on Debian,
>               /dev/disk/by-id/md-name-XXXX
> 	and   /dev/disk/by-id/md-uuid-UUUU
>        will be created (by udev).
>     c/ If there is a 'name' associated with the array then
>         /dev/md/name will be created as a link.
>     d/ if an explicit device name of /dev/name was given,
>         either on a -A, -B, -C, command or in mdadm.conf,
> 	then the 'name' must match the name of the array,
> 	and /dev/name will be used as well as /dev/md/name.

I think all these symlinks are problematic.  We have a naming
consistency problem, and creating all these links just perpetuates that
problem.  I would be in favor of standardizing the namespace location
and semantics and doing away with all the symlinks.  Do that, and within
one release cycle all the confusion will be gone.

>  3/ For a 'NAME' to be used, with as md-name-NAME or /dev/md/NAME,
>     we need a high degree of confidence that the array was intended
>     for "this" host, or otherwise is not going to conflict with
>     an array that is meant for "this" host.
>     We get this confidence in a number of ways:
>     a/ If the name is listed in /etc/mdadm.conf=20
>        e.g.  ARRAY /dev/md/home UUID=3DXXXX.....
>     b/ If the name was given on the command line
>     b/ If the name is stored in the metadata of an array which is
>        explicitly identifed in mdadm.conf or by the command line.
>     c/ If the name is of the form  "host:name" and "host" matches
>        this host.  We then use just "name".
>     d/ If the name is of the form "host:name" and "host" does not
>        match this host, we can still assume that "host:name" is
>        unique and use that.
>     e/ For 0.90 metadata, if the uuid has the host name encoded in it
>        then it was intended for 'this' host.
>=20
>     Thus unsafe names are names extracted from the metadata of arrays
>     which are auto-detected, where there is no hint in the metadata
>     that the array is built for 'this' host.
>=20
>     If the NAME is not known to be safe, we can still assemble the
>     array, but we use a "random" high minor number, and allow it
>     to be found primarily by the by-id/md-uuid-UUUUU... link or some
>     other link created based on array content: e.g. disk/by-label/
>     Also the array will be assembled "auto-readonly" so no resync etc
>     will happen until the array is actually used.

There's no need to make autostarted arrays that we can't identify as
being intended solely for this host hard to find.  It's a little tricky
if there's no homehost in the array, so let's skip that for a second.
If there *is* a homehost, and we don't list the array in mdadm.conf or
it doesn't match our homehost, then I think the answer is to just start
the array auto-readonly with the name /dev/md/homehost:name.  Since we
are assuming that homehost:name is unique even if it isn't our device,
then that means it's sufficient for naming the device uniquely in
our /dev/md space.  Now, if we don't have a homehost on the array, then
I would do as you suggest and use a random high device number and have
udev create any appropriate links.  Of course, udev would make those
same links on devices with a homehost, so the final difference is just
that you create a homehost:name device when possible, skip it when not.
All the rest is the same.

>     mdadm-3.0 will be able to support "containers" such as a set of
>     devices with DDF metadata.  These can then contain a number of
>     different arrays.  If the 'container' is known to be local to
>     'this' host, then we assume that all contained arrays are too.
>=20
>     I'm contemplating creating a link based on the metadata type with
>     a sequential number. e.g. /dev/md/ddf1 or /dev/md/imsm2.
>     I'm not sure if there should be in /dev/md/ or directly in /dev/.
>     I'm also not sure if I should leave the creation to udev, and
>     whether I should use a small sequential number, or just whatever
>     number was allocated as the minor number of the device.
>=20
>  4/ When we stop an array, mdadm will remove anything from /dev that
>     it probably created.
>     In particular, it will remove the device node as described in 1,
>     any partitions, and any symlinks in /dev or /dev/md which point to
>     any of those.  I need to be certain that this won't confuse udev.
>=20
>  5/ I want to enable assembly without having to give
>     an explicit device name, thus requiring mdadm to automatically
>     assign one just as it would for auto-assembly.
>     In particular, the "ARRAY" line in mdadm.conf will no longer
>     require an array name.  That would mean that "-Es" wouldn't need
>     to produce an array name (which is not always easy).
>     So:
>         mdadm -Es > /tmp/mdadm.conf
> 	mdadm -Asc/tmp/mdadm.conf
>     would leave the choice of device name to the "-A" stage which is
>     the only time that unique non-predictable names can be chosen.
>=20
>  6/ I'm thinking that if the array name given to --create or
>     --assemble looks as though it identifies a metadata type, by
>     having the name of a metadata type followed by some digits,
>     e.g. /dev/ddf0 or /dev/md/imsm3
>     then we insist that the array have that metadata type.
>     That could mean that a future metadata type might conflict with
>     a previously valid usage, which would be a bore.
>     Maybe if there are trailing digits, then it *must* identify a
>     metadata type, or be "mdNN".
>=20
> Some issues that all of this needs to address:
>=20
>  1/ People want auto-assembly.  I've always fought against it (we
>     don't auto-mount all filesystems do we?).  But it is a loosing
>     battle.  And on a modern desktop, when you plug in a new drive the
>     filesystem is automatically mounted.  So my argument is falling
>     apart.
>=20
>  2/ Auto-assembly of new arrays must not conflict with auto-assembly
>     of previously existing arrays, even if the devices comprising the
>     new arrays are discovered earlier.  This is what the 'homehost'
>     concept is for.  Your array will only get assembled with a
>     predictable name if it is known to be attached to 'this' host.

Really, with the advent of mount-by-label filesystem usage, this
argument has become less legitimate.  That's not to say that using
homehost intelligently isn't desirable, but even if there is a name
conflict, and the wrong array gets assembled first, it really doesn't
matter since the upper layers will detect the proper filesystem by
filesystem label or uuid and use whatever device contains the filesystem
they want.  So, I would treat homehost as a convenience and a hint, but
I wouldn't allow lack of homehost or wrong homehost to prevent assembly.

>  3/ Auto-assembly needs to handle incremental arrival of devices
>     correctly.  There are no easy solutions to this, particularly when
>     e.g. ext3 can write to the device even when mounted read-only (for
>     journal replay).
>     I think the best that I can do for now is assemble things
>     'read-auto' to delay any writes a long as possible in the hope
>     that all available devices will be connected by then.
>     Adding in-memory bitmaps for all degraded array to accelerate
>     rebuild would help but won't be in 2.6.28.

My solution to this was to only auto-assemble unknown devices if they
are complete.  I think there is an argument to be made that if an array
isn't a normal array on a machine, then degraded assembly is not a
given.

>  4/ auto-assembly needs to do the right thing on a SAN where multiple
>     hosts can each see multiple arrays.  Clearly only one host should
>     write to any one array at one time (until I get some
>     cluster-awareness going, which I had hoped to work on this year,
>     but it doesn't look like I will).
>     In this case, I don't think read-auto is enough.  We either need
>     to not assemble arrays when aren't known to belong to us, or we
>     need to assemble them read-only and require and explicit
>     read-write setting.
>=20
>     So we need some way to know which devices could be visible to
>     other hosts.
>     I could have a global flag in mdadm.conf "Options SAN"
>     I could have a SAN-DEVICES to match "DEVICES", but as just about
>     everything is "/dev/sd*" these days, I don't know if that would
>     work.
>=20
>     Any suggestions concerning this would be welcome.

The scariest suggestion, but probably the most complete and automated,
would be to have mdadm do a search on any constituent devices to find
out what the eventual low level driver is.  If it's a fiber channel
driver, or iSCSI, then don't auto assemble.  If it's sata/e-sata, or
local SAS, then it's more likely auto assemble is fine.  But, that level
of mucking around in /sys for each device would probably be quite ugly.

> I'm also wondering if I should include a udev 'rules' file for md in
> the mdadm distribution.  Obviously it would be no more than a
> recommendation, but it might give me a voice in guiding how udev
> interacted with mdadm.

Actually, this would probably be very helpful.  For instance, that udev
rules file is probably the way you decide whether mdadm or udev
creates/deletes all the links.  The actions of mdadm and udev have to be
synchronized in order to avoid confusion about responsibilities.

> Any thoughts of any of this would be most welcome.
>=20
> Thanks,
> NeilBrown
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-tQmbLkT/5P3EWUFdc0+v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkJ7HcACgkQTzP9PM7pjw93BgCfVpjDfq1WTW61Ko54xILqKw3o
BKsAmwS+zvpodiOjtHi6slfPhsAlo0h8
=oLZ+
-----END PGP SIGNATURE-----

--=-tQmbLkT/5P3EWUFdc0+v--

