From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [BUG] Raid5 trouble
Date: Fri, 19 Oct 2007 08:51:43 -0700
Message-ID: <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>
	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>
	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>
	 <47181CB2.1060602@tmr.com>  <471864F8.9010209@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471864F8.9010209@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-10-19 at 01:04 -0700, BERTRAND Jo=C3=ABl wrote:
>         I never see any oops with this patch. But I cannot create a
> RAID1 array
> with a local RAID5 volume and a foreign RAID5 array exported by iSCSI=
=2E
> iSCSI seems to works fine, but RAID1 creation randomly aborts due to =
a
> unknown SCSI task on target side.

=46or now I am going to forward this patch to Neil for inclusion in
-stable and 2.6.24-rc.  I will add a "Tested-by: Jo=C3=ABl Bertrand
<joel.bertrand@systella.fr>" unless you have an objection.

>         I have stressed iSCSI target with some simultaneous I/O
> without any
> trouble (nullio, fileio and blockio), thus I suspect another bug in
> raid
> code (or an arch specific bug). The last two days, I have made some
> tests to isolate and reproduce this bug:
> 1/ iSCSI target and initiator seem work when I export with iSCSI a
> raid5
> array;
> 2/ raid1 and raid5 seem work with local disks;
> 3/ iSCSI target is disconnected only when I create a raid1 volume ove=
r
> iSCSI (blockio _and_ fileio) with following message:
>=20
> Oct 18 10:43:52 poulenc kernel: iscsi_trgt: cmnd_abort(1156) 29 1 0 4=
2
> 57344 0 0
> Oct 18 10:43:52 poulenc kernel: iscsi_trgt: Abort Task (01) issued on
> tid:1 lun:0 by sid:630024457682948 (Unknown Task)
>=20
>         I run for 12 hours some dd's (read and write in nullio)
> between
> initiator and target without any disconnection. Thus iSCSI code seems
> to
> be robust. Both initiator and target are alone on a single gigabit
> ethernet link (without any switch). I'm investigating...

Can you reproduce on 2.6.22?

Also, I do not think this is the cause of your failure, but you have
CONFIG_DMA_ENGINE=3Dy in your config.  Setting this to 'n' will compile
out the unneeded checks for offload engines in async_memcpy and
async_xor.
>=20
>         Regards,
>         JKB

Regards,
Dan
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
