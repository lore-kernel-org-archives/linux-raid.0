From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Distributed spares
Date: Tue, 14 Oct 2008 06:12:29 -0400
Message-ID: <yq11vyjcwoi.fsf@sermon.lab.mkp.net>
References: <48F3C2A1.3080607@tmr.com>
	<alpine.DEB.1.10.0810131810570.16807@p34.internal.lan>
	<a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com>
	<20081013232921.GB22265@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081013232921.GB22265@rap.rap.dk> ("Keld =?iso-8859-1?Q?J?=
 =?iso-8859-1?Q?=F8rn?= Simonsen"'s message of "Tue\, 14 Oct 2008 01\:29\:21
 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Billy Crook <billycrook@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Keld" =3D=3D Keld J=F8rn Simonsen <keld@dkuug.dk> writes:

Keld> I have also been thinking a little on this. My idea is that if
Keld> bit errors develop on disks, then there is first maybe one bit
Keld> error, and the crc check on the disk sectors then finds and
Keld> corrects these.

Keld> If you rewrite such bit errors, then that bit error will be
Keld> corrected, and you prevent the one-bit error from developing to
Keld> a two-bit error that is not correctable by the CRC.

I think you are assuming that disks are much simpler than they
actually are.

A modern disk drive protects a 512-byte sector with a pretty strong
ECC that's capable of correcting errors up to ~50 bytes.  Yes, that's
bytes.

Also, many drive firmwares will internally keep track of problematic
media areas and rewrite or reallocate affected blocks.  That includes
stuff like rewriting sectors that are susceptible to bleed due to
being adjacent to write hot spots.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
