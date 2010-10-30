From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: 3T drives and RAID
Date: Sat, 30 Oct 2010 10:33:12 +0200
Message-ID: <20101030103312.7b5a2107@zealot>
References: <2F.34.13137.FB29BCC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rUdannK7yLQFBEhTUOt76NH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2F.34.13137.FB29BCC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rUdannK7yLQFBEhTUOt76NH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Leslie,

Please note: I don't have any hands-on experience with drives over 2TB
in size, but I'm interested in the subject as well, and so I will reply
with what (I think) I know nonetheless ;)

On Fri, 29 Oct 2010 22:36:27 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 	WD has finally released a 3T drive employing 4K sectors and
> Advanced Formatting.  I have some questions about Linux / RAID
> compatibility.  The compatibility chart says using the drive with
> Linux requires employing the included HBA.  Is the HBA really
> required if the system will not be booting from the drive? =C2=A0Why?

I don't think that's really the case. The real troublemaker for
common SOHO computer setups with drives that big are not the hardware or
the ATA protocol (there's theoretical support for drives as large as 2
PetaBytes since ATA-6, aka UDMA/100 for EIDE/PATA drives), but simply
MBR partitions. So if your goal isn't booting off of an MBR partition
that's as large as your whole drive (or larger than 2TB, for that
matter), you shouldn't run in any problems. Using advanced partitioning
schemes (like GPT) or LVM on GNU/Linux, for example, should be able to
deal with partition size above 2TB perfectly well.

> What is the minimum kernel version required? =C2=A0I am wanting to use
> these on a RAID6 array with no drive partitioning underneath the
> array (raw disks) using md / mdadm. =C2=A0I'm using a pair of PM based
> eSATA RAID enclosures to house the drives, so if I need to replace my
> adapters, the replacements will need to have eSATA ports (at least 4
> per card) compatible with PM enclosures, which the included HBAs do
> not have.  I'm not sure if the little Sil3124 adapters I currently
> have will fill the bill.  Performance is not a big issue.

I don't think you'll run into problems with that kind of setup, either.
Support for SATA Port Multipliers are a matter of the controller and its
driver (check libata docs if your combination is supported - if memory
serves, Sil3xxx _do_ support PMs), and as I said before, the ATA
standard - and therefore, compliant devices - should cope with drives >
2TB quite well. Your enclosures presumably are dumb devices anyway,
and don't contain any ICs or logic that would interfere with the data on
the link between the HBA's SATA port and your drives.

> 	In addition, I am going to need to add capacity to my existing
> arrays well before I have the money to replace them completely with 3T
> drives.  I'm going to need six 3T drives per array to completely
> replace the 1T and 1.5T drives currently in use.  In the mean time, I
> could upgrade the existing arrays with 1T and 1.5T drives, but that
> money would be more or less wasted when the drives are replaced in a
> few months.  I would much rather buy a couple of 3T drives and move
> them over to the new array when it gets built.  Will there be an
> issue with attempting to add a 4K sector drive to a RAID6 array built
> out of 512 byte sectors?

I don't think so, since you can treat "Advanced Format" drives as
though as they were 512b sector drives, with the drawback of severly
degraded write performance. With md's common values for chunk-size (64k
and more), you should have no problems like the hugely increased write
penalty you get when incorrectly aligning your writes so they don't
take care of sector boundaries. If you're not using partitions but
whole drives as the building blocks of your array anyway, and your chunk
size is an integer multiple of the drives' 4k sector size, you should be
fine.

Corrections to the above are, of course, very welcome. Hth!

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www: http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp: johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.

--Sig_/rUdannK7yLQFBEhTUOt76NH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzL2EgACgkQnnUApj8OcoLpmQCgqcRNRxy/T8CzBODRBpoDjg04
WuIAoIdD2FTlYi7mg9C7Fgzb1KoYNuIG
=tTlV
-----END PGP SIGNATURE-----

--Sig_/rUdannK7yLQFBEhTUOt76NH--
