From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: SpareMissing event, but spare not missing
Date: Wed, 15 May 2013 17:24:29 +0200 (CEST)
Message-ID: <11898309.36.1368631469489.JavaMail.root@zimbra>
References: <CANU9nTm_TpyomQVSHNtQHVNMwRNKrZjs=YUv5PYmKoTV61Gvsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nTm_TpyomQVSHNtQHVNMwRNKrZjs=YUv5PYmKoTV61Gvsg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <tange@binf.ku.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

- Anything in dmesg?
- What does /etc/mdadm/mdadm.conf say?

Also, using 20 disks in a single RAID-6 gives you the same chances for =
a parity+1 error (or worse) as compared to 10 drives in RAID-5. I would=
 really recommend using smaller (8+2?) RAID-6 sets and rather use LVM o=
n top (which you may be doing already?). Even with proper cooling and e=
nterprise drives, 20 drives in a single RAID-6 is asking for trouble=E2=
=80=A6

roy

----- Opprinnelig melding -----
> The last couple of days I have received a warning about a missing
> spare for a device that has several spares.
>=20
> A SparesMissing event had been detected on md device /dev/md1.
> :
> md1 : active raid6 sdas[12](S) sdx[0] sdaq[11](S) sdau[13](S)
> sdah[9] sdaf[8] sdae[7] sdad[6] sdac[5] sdab[4] sdaa[3] sdz[2] sdy[1]
> 31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/10] [UUUUUUUUUU]
> bitmap: 0/2 pages [0KB], 1048576KB chunk
>=20
> I have tried removing one of the spares and adding it again. Same
> error.
>=20
> $ mdadm --version
> mdadm - v3.1.4 - 31st August 2010
> $ uname -a
> Linux orsted 3.2.0-0.bpo.1-amd64 #1 SMP Sat Feb 11 08:41:32 UTC 2012
> x86_64 GNU/Linux
>=20
> /Ole
>=20
>=20
> The automated mail:
>=20
> This is an automatically generated mail message from mdadm
> running on orsted
>=20
> A SparesMissing event had been detected on md device /dev/md1.
>=20
> Faithfully yours, etc.
>=20
> P.S. The /proc/mdstat file currently contains the following:
>=20
> Personalities : [raid6] [raid5] [raid4] [raid0]
> md3 : active raid0 md1[0] md2[1]
> 62512275456 blocks super 1.2 512k chunks
>=20
> md2 : active raid6 sdat[10] sdaj[0] sdao[8] sdag[7] sdap[6] sdan[5]
> sdai[4] sdam[3] sdal[2] sdak[1]
> 31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/10] [UUUUUUUUUU]
> bitmap: 0/2 pages [0KB], 1048576KB chunk
>=20
> md1 : active raid6 sdas[12](S) sdx[0] sdaq[11](S) sdau[13](S) sdah[9]
> sdaf[8] sdae[7] sdad[6] sdac[5] sdab[4] sdaa[3] sdz[2] sdy[1]
> 31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/10] [UUUUUUUUUU]
> bitmap: 0/2 pages [0KB], 1048576KB chunk
>=20
> md0 : active raid6 sdw[28](S) sdd[25] sdu[19] sdv[22] sdp[26] sds[16]
> sdr[15] sdq[14] sdo[23] sdn[12] sdm[11] sdl[10] sdk[9] sdj[8] sdi[7]
> sdh[6] sdc[20] sdf[4] sde[3] sdb[21] sdt[24]
> 52744776192 blocks super 1.2 level 6, 256k chunk, algorithm 2
> [20/20] [UUUUUUUUUUUUUUUUUUUU]
> bitmap: 1/2 pages [4KB], 1048576KB chunk
>=20
> unused devices: <none>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
