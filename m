From: "Giles A. Radford" <me@moof.org.uk>
Subject: Converting existing Data to RAID5
Date: Fri, 2 May 2003 19:26:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030502172613.GA20267@moof.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi there,

I currently have 5 Maxtor 120GB drives, and I'm thinking of converting
them to a RAID 5 array. I know I'll lose the storage space equivalent
to one of those drives, but I'd like to avoid as much disk-shovelling
as possible for the rest, because at the moment I'm limited to a
CD-Writer for backup, and even if I get a DVD writer, it's still a
heck of a lot of shovelling to do.

So what I'm really looking to do is:
* Create the Raid Array with the minimum of drives possible (which am
I right in assuming can be two to start with?)
* Copy data over and then expand the array as I finish copying each
disk over.

Now, Having read back on this list the stock answer to "I want to
expand my RAID5 array" seems to be (at the moment) "Use raidreconf,
but at your own risk, and it'll take ages". I don't have a problem with
the "ages" bit, but I'd like to be as datasafe as possible.

Having found, somewhere, the Boot + Root + Raid + Lilo: Software Raid
Mini-HOWTO <http://www.tldp.org/HOWTO/mini/Boot+Root+Raid+LILO.html>
it talks about setting up RAID arrays with failed disks which you can
then raidhotadd into the array later, although it mostly talks about
Raid 1 and mentions Raid 5 as an afterthought. So I'm wondering:

Could I start up a Raid 5 array with one or two real disks and three
or four faulty drives which I would then activate as and when copying
=66rom them onto the new array has finished? Is this any safer then
using raidreconf? Do I just have completely the wrong end of the stick?

On a slightly similar note, I'm used to using ext2 and ext3, but I've
heard a lot of people talk positively about XFS recently, so I'm
wondering if any of you have any opinions on whether I should use ext3
or XFS for this new array?

Thanks in advance for your advice,=20
Moof
--=20
G.A.Radford_        | Moofing at you from Mallorca, Spain
|\/| _  _ |_ me@    | Take a glimpse into the microCosm: =20
|  |(_)(_)| .org.uk |        http://moof.org.uk/=20

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+sqo1W3YaO5gYTxkRAueZAJ4y1njdPwda4PbzKDesV0GUfnJlYgCfTYWB
MLWIDtqq9X3vvF8u3huQE2U=
=LFxi
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
