From: NeilBrown <neilb@suse.de>
Subject: Re: Persistent failures with simple md setup
Date: Tue, 5 Feb 2013 14:44:48 +1100
Message-ID: <20130205144448.2f40b306@notabene.brown>
References: <1565063.1kpR7lz4Ph@xrated>
	<5108E2CC.4010806@profitbricks.com>
	<2432282.A1IPyQ9pEc@xrated>
	<2286786.BnthJ2WIKW@xrated>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/E094ab7HafN0oms4MoQhs2Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2286786.BnthJ2WIKW@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

--Sig_/E094ab7HafN0oms4MoQhs2Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Feb 2013 21:43:29 +0100 Hans-Peter Jansen <hpj@urpla.net> wrote:

> Am Mittwoch, 30. Januar 2013, 18:12:46 schrieb Hans-Peter Jansen:
> >=20
> > Hmm, according to mdadm from openSUSE:12.1:Update, the relevant fixes s=
hould
> > be in place. It might be an unfortunate combination of this issue and t=
he
> > asynchronously applied updates, interfered by the *switching* behavior.
> >=20
> > I started with regenerating the initrds now, and a first reboot succeed=
ed so
> > far. Good.
> >=20
> > Will ask my friend to reboot the system a dozen times tonight.
>=20
> After a few reboots, the issue reappeared. I really believe now, that by
> driving the md in degraded mode for some time and with the switching beha=
vior,=20
> just re-adding the devices resulted in unsynced raid1 devices.
>=20
> Next, my friend managed to create a nearby data disaster: I've explained =
him,
> how he would be able to re-add a device himself. He did so on sunday with=
 his
> home partition, and since there appeared no progress bar in /proc/mdstat,=
 he=20
> immediately repeated the command.=20
>=20
> Neil, is it conceivable (due to a race or the like), that repeating to ad=
d=20
> (re-add) a device potentially creates data salad, since that home-fs (xfs=
)=20
> gone mad a few minutes later (firefox crashed, and couldn't be started, k=
mail=20
> crashed, and so on (all those processes, that write to ~). He decided to=
=20
> reboot, and that jailed him in the emergency recovery console, because /h=
ome=20
> couldn't be mounted anymore.

There was a bug prior to 2.6.37 (fixed by commit 1a855a0606653d2) which
sounds vaguely related, but you seem to be running a 3.0.x kernel(?) so
shouldn't be affected by that.

Without logs of precisely what happened, it is very hard to guess.



> Today, I hammered the raid1 partitions with "check". During one run, this=
=20
> appeared in syslog:
>=20
> Feb  4 11:18:26 zaphkiel kernel: [11165.652478] ata2.00: exception Emask =
0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> Feb  4 11:18:26 zaphkiel kernel: [11165.652486] ata2.00: irq_stat 0x40000=
008
> Feb  4 11:18:26 zaphkiel kernel: [11165.652495] ata2.00: failed command: =
READ FPDMA QUEUED
> Feb  4 11:18:26 zaphkiel kernel: [11165.652510] ata2.00: cmd 60/80:e0:12:=
ef:c2/00:00:0c:00:00/40 tag 28 ncq 65536 in
> Feb  4 11:18:26 zaphkiel kernel: [11165.652513]          res 41/40:53:3f:=
ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
> Feb  4 11:18:26 zaphkiel kernel: [11165.652520] ata2.00: status: { DRDY E=
RR }
> Feb  4 11:18:26 zaphkiel kernel: [11165.652524] ata2.00: error: { UNC }
> Feb  4 11:18:26 zaphkiel kernel: [11165.652876] ata2.00: failed to IDENTI=
FY (I/O error, err_mask=3D0x100)
> Feb  4 11:18:26 zaphkiel kernel: [11165.652882] ata2.00: revalidation fai=
led (errno=3D-5)
> Feb  4 11:18:26 zaphkiel kernel: [11165.652890] ata2: hard resetting link
> Feb  4 11:18:26 zaphkiel kernel: [11165.957043] ata2: SATA link up 3.0 Gb=
ps (SStatus 123 SControl 300)
> Feb  4 11:18:26 zaphkiel kernel: [11165.969910] ata2.00: configured for U=
DMA/133
> Feb  4 11:18:26 zaphkiel kernel: [11165.970048] ata2: EH complete
> Feb  4 11:18:28 zaphkiel kernel: [11167.949241] ata2.00: exception Emask =
0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> Feb  4 11:18:28 zaphkiel kernel: [11167.949249] ata2.00: irq_stat 0x40000=
008
> Feb  4 11:18:28 zaphkiel kernel: [11167.949257] ata2.00: failed command: =
READ FPDMA QUEUED
> Feb  4 11:18:28 zaphkiel kernel: [11167.949272] ata2.00: cmd 60/80:10:12:=
ef:c2/00:00:0c:00:00/40 tag 2 ncq 65536 in
> Feb  4 11:18:28 zaphkiel kernel: [11167.949275]          res 41/40:53:3f:=
ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
> Feb  4 11:18:28 zaphkiel kernel: [11167.949282] ata2.00: status: { DRDY E=
RR }
> Feb  4 11:18:28 zaphkiel kernel: [11167.949287] ata2.00: error: { UNC }
> Feb  4 11:18:28 zaphkiel kernel: [11167.962146] ata2.00: configured for U=
DMA/133
> Feb  4 11:18:28 zaphkiel kernel: [11167.962206] ata2: EH complete
> Feb  4 11:18:30 zaphkiel kernel: [11169.898187] ata2.00: exception Emask =
0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> Feb  4 11:18:30 zaphkiel kernel: [11169.898195] ata2.00: irq_stat 0x40000=
008
> Feb  4 11:18:30 zaphkiel kernel: [11169.898204] ata2.00: failed command: =
READ FPDMA QUEUED
> Feb  4 11:18:30 zaphkiel kernel: [11169.898219] ata2.00: cmd 60/80:e0:12:=
ef:c2/00:00:0c:00:00/40 tag 28 ncq 65536 in
> Feb  4 11:18:30 zaphkiel kernel: [11169.898222]          res 41/40:53:3f:=
ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
> Feb  4 11:18:30 zaphkiel kernel: [11169.898229] ata2.00: status: { DRDY E=
RR }
> Feb  4 11:18:30 zaphkiel kernel: [11169.898234] ata2.00: error: { UNC }
> Feb  4 11:18:30 zaphkiel kernel: [11169.912066] ata2.00: configured for U=
DMA/133
> Feb  4 11:18:30 zaphkiel kernel: [11169.912117] ata2: EH complete
> Feb  4 11:18:32 zaphkiel kernel: [11171.905192] ata2.00: exception Emask =
0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> Feb  4 11:18:32 zaphkiel kernel: [11171.905200] ata2.00: irq_stat 0x40000=
008
> Feb  4 11:18:32 zaphkiel kernel: [11171.905208] ata2.00: failed command: =
READ FPDMA QUEUED
> Feb  4 11:18:32 zaphkiel kernel: [11171.905223] ata2.00: cmd 60/80:10:12:=
ef:c2/00:00:0c:00:00/40 tag 2 ncq 65536 in
> Feb  4 11:18:32 zaphkiel kernel: [11171.905226]          res 41/40:53:3f:=
ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
> Feb  4 11:18:32 zaphkiel kernel: [11171.905233] ata2.00: status: { DRDY E=
RR }
> Feb  4 11:18:32 zaphkiel kernel: [11171.905238] ata2.00: error: { UNC }
> Feb  4 11:18:32 zaphkiel kernel: [11171.919099] ata2.00: configured for U=
DMA/133
> Feb  4 11:18:32 zaphkiel kernel: [11171.919152] ata2: EH complete
> Feb  4 11:18:34 zaphkiel kernel: [11173.912191] ata2.00: exception Emask =
0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> Feb  4 11:18:34 zaphkiel kernel: [11173.912199] ata2.00: irq_stat 0x40000=
008
> Feb  4 11:18:34 zaphkiel kernel: [11173.912208] ata2.00: failed command: =
READ FPDMA QUEUED
> Feb  4 11:18:34 zaphkiel kernel: [11173.912223] ata2.00: cmd 60/80:e0:12:=
ef:c2/00:00:0c:00:00/40 tag 28 ncq 65536 in
> Feb  4 11:18:34 zaphkiel kernel: [11173.912226]          res 41/40:53:3f:=
ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
> Feb  4 11:18:34 zaphkiel kernel: [11173.912233] ata2.00: status: { DRDY E=
RR }
> Feb  4 11:18:34 zaphkiel kernel: [11173.912238] ata2.00: error: { UNC }
> Feb  4 11:18:34 zaphkiel kernel: [11173.925101] ata2.00: configured for U=
DMA/133
> Feb  4 11:18:34 zaphkiel kernel: [11173.925159] ata2: EH complete
> Feb  4 11:18:36 zaphkiel kernel: [11175.861152] ata2.00: exception Emask =
0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> Feb  4 11:18:36 zaphkiel kernel: [11175.861160] ata2.00: irq_stat 0x40000=
008
> Feb  4 11:18:36 zaphkiel kernel: [11175.861168] ata2.00: failed command: =
READ FPDMA QUEUED
> Feb  4 11:18:36 zaphkiel kernel: [11175.861183] ata2.00: cmd 60/80:10:12:=
ef:c2/00:00:0c:00:00/40 tag 2 ncq 65536 in
> Feb  4 11:18:36 zaphkiel kernel: [11175.861186]          res 41/40:53:3f:=
ef:c2/00:00:0c:00:00/40 Emask 0x409 (media error) <F>
> Feb  4 11:18:36 zaphkiel kernel: [11175.861193] ata2.00: status: { DRDY E=
RR }
> Feb  4 11:18:36 zaphkiel kernel: [11175.861198] ata2.00: error: { UNC }
> Feb  4 11:18:36 zaphkiel kernel: [11175.874052] ata2.00: configured for U=
DMA/133
> Feb  4 11:18:36 zaphkiel kernel: [11175.874103] sd 1:0:0:0: [sdb] Unhandl=
ed sense code
> Feb  4 11:18:36 zaphkiel kernel: [11175.874109] sd 1:0:0:0: [sdb]  Result=
: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Feb  4 11:18:36 zaphkiel kernel: [11175.874117] sd 1:0:0:0: [sdb]  Sense =
Key : Medium Error [current] [descriptor]
> Feb  4 11:18:36 zaphkiel kernel: [11175.874125] Descriptor sense data wit=
h sense descriptors (in hex):
> Feb  4 11:18:36 zaphkiel kernel: [11175.874130]         72 03 11 04 00 00=
 00 0c 00 0a 80 00 00 00 00 00=20
> Feb  4 11:18:36 zaphkiel kernel: [11175.874145]         0c c2 ef 3f=20
> Feb  4 11:18:36 zaphkiel kernel: [11175.874153] sd 1:0:0:0: [sdb]  Add. S=
ense: Unrecovered read error - auto reallocate failed
> Feb  4 11:18:36 zaphkiel kernel: [11175.874163] sd 1:0:0:0: [sdb] CDB: Re=
ad(10): 28 00 0c c2 ef 12 00 00 80 00
> Feb  4 11:18:36 zaphkiel kernel: [11175.874180] end_request: I/O error, d=
ev sdb, sector 214101823
> Feb  4 11:18:36 zaphkiel kernel: [11175.874234] ata2: EH complete
> Feb  4 11:18:38 zaphkiel kernel: [11177.954091] md: md124: data-check don=
e.
>=20
> This is a classical URE, isn't it? Interestingly, nonetheless, the raid1 =
check=20
> run succeeded! (Not so good, is it?)

What?  Success not good?  :-)

md didn't report any errors.  Maybe it didn't see any.  Where is sector
214101823?



> Last question: since I had to massage the system anyway, I've updated mda=
dm=20
> from 3.2.2 to 3.2.6. I red, that it can be dangerous to do so, what do I =
risk
> here?

Where did you read that?
If you find you need to re-create an array with "--create", a different mda=
dm
might give a different result, which wouldn't be what you want.  Otherwise =
it
should be safe.

NeilBrown


--Sig_/E094ab7HafN0oms4MoQhs2Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURCAMDnsnt1WYoG5AQJEjxAApE/lhzf/+qm0RpnpnbweVKuvufsToX/i
RpABG8xp70J2NP8gAFUBL6hKgE+kD8zNmVuMLR2YJS12cRQIK8s5KFJxn/qToBRC
umsHL6+X0AloveSSf7Jc960pFZ6GyVb/Cp5U0sYObX1Hcz0i9xegeE1RByzGFKHb
4zJQ3ZW2AVtIJ2jICZXJG9MnijPhZHy8uaWW9anepIePnIuXRVGZpAaebAptk1gL
iM+XuWXUeGDC9f2RHmfBYDTI4hl4s88BswrQBx8uNeCsKL/kh0hJVUMdPJOiyFRR
8NT5GbxWAMOJ0Rj0srmr64dBfCA9M0R3SPXWZcDbUzMn90lq2ue2PoLssyjaMl66
OoxHCS+al06fZqaRi52l2BFbgkd3WRI4/eSE+tLm6rZFWUh8BIcuRatKXxZBMF5v
dVUhtdCFYIAGN9nvGl8bXKomIjThjXH1W+ClbGzKYpsz2QbUiekzJ+6H8Uu5fUXS
ruk1DZVr6IYF1eNWw0ddlphjwpcRuxqmAlTUHo3KDB0dB2DNZiJI1Emkre2UGH87
ppyENaG5gcdr9Cxpy0Uh4L3juMnx7rwkOLrc5Wy2DJ1qXNe9g0cmmTyepZnMokWh
SoDVeEFLkE2qWrkpp1EOIPGe5xy8lA5/ds2FdY8IrMXyxJXi6hjWQqCm1YiMIj9Y
FbnKZiuwJLQ=
=bETu
-----END PGP SIGNATURE-----

--Sig_/E094ab7HafN0oms4MoQhs2Z--
