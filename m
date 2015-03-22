From: NeilBrown <neilb@suse.de>
Subject: Re: is mdadm RAID1 disk full sync
Date: Sun, 22 Mar 2015 14:20:33 +1100
Message-ID: <20150322142033.0af10b1a@notabene.brown>
References: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dlJ1NEHliw/4FBLasZGXM1N"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: lingli tang <tanglingli001@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dlJ1NEHliw/4FBLasZGXM1N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Mar 2015 19:01:54 +0800 lingli tang <tanglingli001@gmail.com>
wrote:

> I am a newbie of mdadm. I have a question but find no answer in
> document or google for last 10 days.
>=20
> The question is : RAID1 made by mdadm is full sync? for example, I
> have two disk(sdb and sdc) to make RAID1 disk (/dev/md127), if I
> commit an IO to the RAID1 disk (md127), it will return back to me when
> all the two disk commit successfully      or      it will return back
> to me once just one of the disk successfully commit.

The write request will not return until it has been submitted to all, and
returned by, all working devices.

>=20
> I have test with xfs and ext4 with sync option, and it seems that two
> disk have lots of commit difference after reboot the server. is that
> means mdadm return success when one of the disk is commit
> successfully?

That certainly shouldn't happen.  I would need more details of the experime=
nt
that you performed.

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/dlJ1NEHliw/4FBLasZGXM1N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQ41ATnsnt1WYoG5AQJ3Jw/8Cs/vKfrUMaHgSpVMmbEHcgHCRs92BCM6
UEcBp6QP03PNUdDmSkfSCCBv7fpVwYOBlVkS73Gs67p8GsNq1HvGdCwBMWdiMVpD
lyzNacVqggRhYcc8afv21oESfqhPj/AyNMOBUP581ksIr7ye5xIaomjT2uyUHjgZ
miIlic4LUsS51H/xz10PzeE1EMsN3D6utd9DPJhUlrMNs6u0vzPR4oMzmmh5+Gsy
QM+tdOPdpKPLWNba7RX4TIWegPhiBEYJygQ90sffsSQZB+vDzNZbJG++hFU1L7II
A81zhm15oTIGZRjiy3HfpV4YUCkKyCZsaedQ4XNXUxvvqe2RL+cy6PduEVBLe5je
TnHFjPnsXbdCn/AgHnfJG+lQ+Z2a1+W8qX6ZRrMg/diIkcEwd3Tv70ik1EZSkCeH
2MW1/typlhHivTYuZhZB6clv9fNgHENBo8+vocuVWa/Oi00nwfPP/P7Vh6Y24vjG
XCVgeVoyOuJX8XPBe/eRHrAj4Kwo4y5Er8SmD3/ewgNZFcU0cV8BYZb41f6SDZ72
olrQouCBtWA8xKkB3FeOhIuUoSDGz4pGkDA5LHM0gR3SLFw1I9ZUirIZYVyAlouv
5qmwwpDytQcbbFU4Vm/UdUqe4P5QCRKVEQwy7zqYuItzSgE3de0Cl7QxASCEXi8D
IvEo5rD7+n8=
=ITTU
-----END PGP SIGNATURE-----

--Sig_/dlJ1NEHliw/4FBLasZGXM1N--
