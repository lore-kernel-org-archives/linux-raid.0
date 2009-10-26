From: Doug Ledford <dledford@redhat.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 20:55:06 -0400
Message-ID: <4AE4F36A.9070504@redhat.com>
References: <627672.61054.qm@web38803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAC7A7300D60709A43CBAD4C0"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <627672.61054.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAC7A7300D60709A43CBAD4C0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/25/2009 12:06 PM, adfas asd wrote:
> --- On Sun, 10/25/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>>     Half the files I have lost on my video
>> system were due to my
>> personal errors.  Absolutely none were due to drive
>> failures.  By a very
>> wide margin, the most common cause of data loss is human
>> error.  EVERY
>> SINGLE FILE THAT HAS EVER BEEN LOST SINCE THE FIRST DIGITAL
>> COMPUTER WAS
>> BUILT HAS BEEN DUE TO THERE NOT BEING A VALID BACKUP.
>=20
> Remember:  I, am not you.  I am trying to tell you *my* actual experien=
ce.

Yes, but in your own words you said in the last 12 years you can only
recall 3 or 4 times when you needed to restore from backup.  Well, 3 or
4 times is not 0, hence you need backups.  A raid array doesn't get the
same thing as backup.

>=20
>>     Here is the e-mail sent by the daily
>> system backup:
>>     What's obscure about that?
>=20
> Well, it doesn't say for dead-bolt sure that there has been a backup an=
d *full*incontravertible*successful*verify*.  If it does, it's not clear.=


Neither did your raid solution, nor does ZFS.  Both raid and ZFS write
the same data to multiple blocks on various disks (well, in 1/10 mode
they do anyway), but if something happens later to make those data
blocks disagree, the raid system won't catch that unless you run a check
of the array.  So, just because it *thinks* things are hunky-dory does
not in fact mean they are.  So, you are applying a double standard here
in that you are expecting things out of the backup solution Leslie
listed that you don't have in your preferred solution.

That being said, you can in fact have what you want by simply telling
rsync to use file MD5 sums to determine which files need synced from the
master to the slave instead of file size/date data.  That's right, you
can, by passing a simple flag to rsync, cause it to read each and every
single file, generate an md5sum of the file, and use that to determine
if the file needs backed up or if the file already on the backup machine
is identical.  In other words, this mode of operation is *superior* to
the raid solution your comparing it against.

But, this all raises a very simple point that I'm surprised someone else
hasn't brought up yet.  If you had merely looked at the rsync man page,
or even just the rsync help information on the command line, you would
have seen this for yourself.  So, might I suggest that before you spend
to much time trying to shoot down what is probably a very workable
solution for you, that you actually *LOOK INTO* that solution instead of
letting prejudice and ignorance drive your decision.

> And what does it take to set up this emailed report?

Run rsync in a cron job and *don't* redirect rsync's output to /dev/null
and you will automatically get these emails (assuming that you already
redirect emails to root to your own personal email account).

> And what backup system/script was used?

Rsync is it's own backup system when used as such, nothing else is
needed.  You essentially create a cron job to run rsync, and your entire
script consists of simply getting the rsync command fine tuned to your
particular application.  Here's an example of an rsync cron job I use to
mirror Fedora repos to my local server:

[root@firewall ~]# more /etc/cron.daily/sync_fedora
#!/bin/bash
#
# Only used on rawhide

cd /srv/Fedora/rawhide
[ -f .syncing ] && exit 0 || touch .syncing
for arch in x86_64 i386 ppc; do
	rsync -acq --delete
rsync://fedora.secsup.org/fedora/linux/development/$arch/os/ $arch
	if [ $arch =3D "x86_64" ]; then
		ln $arch/Packages/*.noarch.rpm i386/Packages >/dev/null 2>&1
		ln $arch/Packages/*.noarch.rpm ppc/Packages >/dev/null 2>&1
		ln $arch/Packages/*.i[356]86.rpm i386/Packages >/dev/null 2>&1
	fi
done
rm .syncing

[root@firewall ~]#

Note that because I use the -q flag to rsync, I don't get nightly emails
unless something goes wrong.

>=20
>>  It's also a simple matter to run a
>> compare between the two systems.  One can compare
>> every single file, or for
>> brevity one can easily compare only the most recently
>> created files.
>=20
> Yes yes, but how?

RTFM please.

>>> Also I've noticed rsync mentioned several times.=20
>> This seems to have
>>> facilities for incremental backups, but I've also read
>> that it is non-
>>> secure over networks and that we should use scp
>> instead.
>>
>>     It's secure if you use ssh with
>> passphraseless keys as its transfer
>> mechanism.  Why are you worried about it if this is a
>> home LAN, though?  How
>> is someone gong to sniff your LAN, especially the link
>> between the two
>> hosts?
>=20
> I am told that use of OpenSSH vastly limits the bandwidth of the connec=
tion, due to encryption overhead.  Backups could cost more than 24 hours =
a day, and/or cut into CPU cycles needed for commercial-flagging.  So I'm=
 looking for secure alternatives.
>=20
> And no I'm not too concerned with someone sniffing my LAN, but if pract=
ical security can be had I always use it.  For example I set up reverse S=
SH tunnels for MythTV, MySQL, and Squid.  No it's not mandatory, and it i=
s difficult, but it is best-practice.

Might I suggest a little less "so I'm told" and a little more "so I
tried this out and this is what I got...".  In this particular case, if
you are worried about the poor authentication of rsync without ssh, but
concerned with the overhead of encrypting all the data transferred, then
why not just set up ssh so that it does encryptionless data transfer
between these two machines?  Then you get the benefit of the improved
authentication strength of ssh, but not the overhead of the encryption
on the link.  But, in truth, as long as you aren't running an atom CPU
or something like that, you should have more than enough CPU horsepower
to encrypt a gigabit link's worth of data transfer.  And especially if
you choose to use the md5sum comparisons in rsync, your machines will be
far busier just reading the data from disk and doing md5sums of the
entire array, so worrying about the CPU overhead of the encryption is
kinda silly.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigAC7A7300D60709A43CBAD4C0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrk82oACgkQg6WylM+/8ZTBAgCgmKzYN1V7+wGrJDQwZ/Sdib+D
r5AAn1ho+nu5sQf8es4uZDqFvuCx8VM5
=b5MU
-----END PGP SIGNATURE-----

--------------enigAC7A7300D60709A43CBAD4C0--
