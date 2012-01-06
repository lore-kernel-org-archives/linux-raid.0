From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Fri, 6 Jan 2012 14:46:25 +0100
Message-ID: <20120106134625.GA3027@vault.local>
References: <4E6F13F7.6070507@truschnigg.info>
 <4E6F4091.7050206@turmel.org>
 <4E6FA76A.90206@truschnigg.info>
 <4E7092F1.5010209@turmel.org>
 <4E70EFA8.4080706@truschnigg.info>
 <4E70FE5B.5080601@turmel.org>
 <20120106105143.GA2932@vault.local>
 <4F06F410.4070807@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F06F410.4070807@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--aVD9QWMuhilNxW9f
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning Phil,

thanks for tuning in again! :)

On Fri, Jan 06, 2012 at 08:16:00AM -0500, Phil Turmel wrote:
> Warning!  I saw bug report on LKML yesterday involving LVM and the brand =
new
> kernel v3.2, so you might want to pull back.  v3.1.5 was known good in th=
at
> report.

Ok, thanks for the warning - will try to find the thread where the bug is
described, and consider downgrading to 3.1.x instead!

> I'm guessing that /dev/sda contains your boot and root filesystems, and t=
hat
> this isn't an error.

You are correct, sorry I did not mention that initially. These devices are =
not
supposed to end up as parts of any md arrays.

> Those slot numbers are *really* important.

What is the significance of the individual slot numbers there?


> Yes, --assemble --force.

Ok, will fire that command as soon as I checked out the LVM bug you mention=
ed.

> May I suggest getting an lsdrv [1] report, which will give you the serial=
 numbers
> of your disks versus the device assignments, for later reference.  And ag=
ain
> after it's all running, for completeness.

I have attached a file with the relevant lsdrv (great little program btw) to
this message - should I expect changes to it after my array is up (well,
except for the components not to be recognized as spare, of course)?

> HTH,

It sure did - thanks a bunch! :)

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp:  johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="lsdrv-output.txt"
Content-Transfer-Encoding: quoted-printable

# ./lsdrv=20
PCI [pata_via] 04:00.0 IDE interface: VIA Technologies, Inc. VT6415 PATA ID=
E Host Controller
=E2=94=9Cscsi 0:0:0:0 ATA TRANSCEND {20090625_D40D51BB}
=E2=94=82=E2=94=94sda 1.87g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=94sda1 1.87g [8:1] ext2 'VIRTUE' {ff586bcd-b1fd-4c08-a0ea-=
08e2e1c7b8f9}
=E2=94=82  =E2=94=94Mounted as /dev/root @ /
=E2=94=94scsi 1:x:x:x [Empty]
PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB=
7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
=E2=94=9Cscsi 2:0:0:0 ATA SAMSUNG HD154UI {S1XWJDWS803396}
=E2=94=82=E2=94=94sdb 1.36t [8:16] MD raid5 (none/5) (w/ sdd,sdf,sdc,sde) s=
pare 'virtue:0' {19e260e6-db3c-ad86-0541-487da1bae605}
=E2=94=82 =E2=94=94md0 0.00k [9:0] MD vNone None (None) inactive, None (Non=
e) 0/sec
=E2=94=82                  Empty/Unknown
=E2=94=9Cscsi 3:0:0:0 ATA SAMSUNG HD154UI {S1XWJDWZ419775}
=E2=94=82=E2=94=94sdc 1.36t [8:32] MD raid5 (none/5) (w/ sdb,sdd,sdf,sde) s=
pare 'virtue:0' {19e260e6-db3c-ad86-0541-487da1bae605}
=E2=94=82 =E2=94=94md0 0.00k [9:0] MD vNone None (None) inactive, None (Non=
e) 0/sec
=E2=94=82                  Empty/Unknown
=E2=94=9Cscsi 4:0:0:0 ATA SAMSUNG HD154UI {S1XWJDWS803467}
=E2=94=82=E2=94=94sdd 1.36t [8:48] MD raid5 (none/5) (w/ sdb,sdf,sdc,sde) s=
pare 'virtue:0' {19e260e6-db3c-ad86-0541-487da1bae605}
=E2=94=82 =E2=94=94md0 0.00k [9:0] MD vNone None (None) inactive, None (Non=
e) 0/sec
=E2=94=82                  Empty/Unknown
=E2=94=9Cscsi 5:0:0:0 ATA SAMSUNG HD154UI {S1XWJDWS803469}
=E2=94=82=E2=94=94sde 1.36t [8:64] MD raid5 (none/5) (w/ sdb,sdd,sdf,sdc) s=
pare 'virtue:0' {19e260e6-db3c-ad86-0541-487da1bae605}
=E2=94=82 =E2=94=94md0 0.00k [9:0] MD vNone None (None) inactive, None (Non=
e) 0/sec
=E2=94=82                  Empty/Unknown
=E2=94=9Cscsi 6:0:0:0 ATA SAMSUNG HD154UI {S1XWJDWS803405}
=E2=94=82=E2=94=94sdf 1.36t [8:80] MD raid5 (none/5) (w/ sdb,sdd,sdc,sde) s=
pare 'virtue:0' {19e260e6-db3c-ad86-0541-487da1bae605}
=E2=94=82 =E2=94=94md0 0.00k [9:0] MD vNone None (None) inactive, None (Non=
e) 0/sec
=E2=94=82                  Empty/Unknown
=E2=94=94scsi 7:x:x:x [Empty]

--k1lZvvs/B4yU6o8G--

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8G+zAACgkQnnUApj8OcoKnkACfe11LwHmcP+4rDzYMnN91n7a6
aIUAn13cnV43DPEdx5//MMEbwiDgjPAf
=bB47
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
