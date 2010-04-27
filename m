From: Doug Ledford <dledford@redhat.com>
Subject: More Hot Unplug/Plug work
Date: Tue, 27 Apr 2010 12:45:23 -0400
Message-ID: <4BD714A3.9020801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDEFABFD3EF9B2ACC27B57B06"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, "Labun, Marcin" <Marcin.Labun@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDEFABFD3EF9B2ACC27B57B06
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

So I pulled down Neil's git repo and started working from his hotunplug
branch, which was his version of my hotunplug patch.  I had to do a
couple minor fixes to it to make it work.  I then simply continued on
from there.  I have a branch in my git repo that tracks his hotunplug
branch and is also called hotunplug.  That's where my current work is at.=


What I've done since then:

1) I've implemented a new config file line type: DOMAIN
   a) Each DOMAIN line must have at least one valid path=3D entry, but ma=
y
      have more than one path=3D entry.  path=3D entries are file globs a=
nd
      must match something in /dev/disk/by-path
   b) Each DOMAIN line must have one and only one action=3D entry.  Valid=

      action items are: ignore, incremental, spare, grow, partition.
      In addition, a word me be prefixed with force- to indicate that
      we should skip certain safety checks and use the device even if it
      isn't clean.
   c) Each DOMAIN line may have a metadata entry, and may have a
      spare-group entry.
   d) For the partition action, a DOMAIN line must have a program=3D and
      a table=3D entry.  Currently, the program=3D entry must be an item
      out of a list of known partition programs (I'm working on getting
      sfdisk up and running, but for arches other than x86, other
      methods would be needed, and I'm planning on adding a method
      that allows us to call out to a user supplied script/program
      instead of a known internal method).  The table=3D entry points to
      a file that contains a method specific table indicating the
      necessary partition layout.  As mentioned in previous mails, we
      only support identical partition tables at this point.  That
      may never change, who knows.

2) Created a new udev rules file that gets installed as
05-md-early.rules.  This rule file, combined with our existing rules
file, is a key element to how this domain support works.  In particular,
udev rules allow us to separate out devices that already have some sort
of raid superblock from devices that don't.  We then add a new flag to
our incremental mode to indicate that a device currently does not belong
to us, and we perform a series of checks to see if it should, and if so,
we "grab" it (I would have preferred a better name, but the short
options for better names were already taken).  When called with the
"grab" flag, we follow a different code path where we check the domain
of the device against our DOMAIN entries and if we have a match, we
perform the specified action.  There will need to be some additional
work to catch certain corner cases, such as the case where we have
force-partition and we insert a disk that currently has a raid
superblock on the bare drive.  We will currently miss that situation and
not grab the device.  So, this is a work in progress and not yet complete=
=2E

3) Add IncrementalNew, IncrementalNewPart, and IncrementalNewDisk to
Incremental.c.  The IncrementalNew is called any time we are passed the
"grab" flag to incremental mode.  In IncrementalNew we merely figure out
if we match a domain entry, and if so then we check if that domain entry
is a partition entry, if it is then we pass it off to
IncrementalNewDisk, if not then we pass it off to IncrementalNewPart
(hmmm...renaming of these functions might be in order...it makes sense
to me, because I was thinking "this is what we do on a bare disk, this
is what we do on a partition", but considering that we call NewDisk on
partition domains and NewPart on everything else seems backwards).
These functions are partial stubs at the moment.  They do some sanity
checks, but not any real work.  However, they aren't intended to do a
lot of work themselves.  They are intended to figure out if they should
do work, then simply invoke Managedevs with the 'a' flag to do the
actual work.  And if the method is grow, then we will call Managedevs
with the 'a' disposition, then call Grow with the right options to do
the right thing.  The point being that all the code necessary to
automatically use a device already exists, we just have to invoke it
automatically instead of requiring a user to invoke it from the command
line.  I'm very big on reusing that existing code and not trying to
duplicate it here.

So, that's where things stand right now.  I'm going to keep working on
this as it's incomplete and doesn't actually do any work at the moment
(it's all sanity checks, config file parsing, and infrastructure, the
actual actions are not yet implemented), but I wanted to get out what I
have currently for people to see.  So, you can check it out here:

git://git.fedorapeople.org/~dledford/mdadm.git hotunplug

Comments welcome.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigDEFABFD3EF9B2ACC27B57B06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvXFKMACgkQg6WylM+/8ZTXQQCgnWUkvuC3Mi4S2YHzMizPmmXy
9v0An0UKULNRj0FCcf4anN+FDBsl+YNb
=ja+4
-----END PGP SIGNATURE-----

--------------enigDEFABFD3EF9B2ACC27B57B06--
