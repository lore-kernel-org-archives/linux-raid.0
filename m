From: Roman Mamedov <roman@rm.pp.ru>
Subject: mdadm freezes the system
Date: Tue, 8 Jun 2010 14:59:13 +0600
Message-ID: <20100608145913.187a69ca@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+blCusCZU15OgQsp1nFvsMy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+blCusCZU15OgQsp1nFvsMy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello.

I am having a strange issue with md RAID on the 2.6.34 kernel. To be
specific, it sometimes locks up the system completely, with the following
symptoms:
- any attempt to read from an array seems to never return
- no errors at all on the server console
- in one lock-up episode I had "top" running, which displayed zero CPU
  load (no mdX_raidX in sight on top of the CPU-load sorted list)
- Alt-SysRQ-B works, and allows to reboot the system

Now, regarding when this happens. I had two such lock-ups shortly after mov=
ing
my root FS to RAID5; after the first one I changed the FS from XFS to Ext4
(this did not help), after the second one I disabled NCQ on all drives and =
the
write intent bitmap on the array. After that, it worked for maybe a week of
intense reads/writes onto the arrays with no more hangs.

Today, I have decided to convert a three-member RAID5 into a four-member
RAID6. mdadm segfaulted(!) right after the --grow command, and dmesg had
an error about md being unable to overwrite the /sys/.....stripe_cache_size
file. (As I understand, this is already fixed in the latest kernel).

The array then started rebuilding as 4-member RAID6 seemingly fine, but
shortly after, the system locked up in the same manner as described above.

Several attempts to do the rebuild after reboots consistently caused the sa=
me
lock-ups early in the rebuild (at less than 1% done). So for now, I decided=
 to
give up and returned the array to its previous RAID5 three-member
configuration, which went fine.

The configuration:
md0 is 3* 1990GB RAID5
md1 is 3* 10GB RAID5 (root FS)
Three drives are 2* WD20EADS and 1* Hitachi 2TB drive. Fourth array member I
was trying to add to md0, is a RAID0 of two 1TB drives (Seagate and Hitachi=
).
SATA controllers are nForce4 chipset and a PCI-E JMicron JMB363. I am using
mdadm 3.1.2 now, and going to try the 2.6.35-rc2 kernel.

So, my question is, does anyone have an idea on what could cause this, and =
what
would be the best way to diagnose/fix the lockup problem?  Thanks in advanc=
e.

--=20
With respect,
Roman

--Sig_/+blCusCZU15OgQsp1nFvsMy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwOBmEACgkQTLKSvz+PZwhAuACeKZQs1koC3u7NK3jg4zs5l+2e
5SIAn3ju1837kExvxJgLS9L/iPzjEmLF
=9H99
-----END PGP SIGNATURE-----

--Sig_/+blCusCZU15OgQsp1nFvsMy--
