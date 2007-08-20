From: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Subject: AW: Mustn't be RAID 1 and 0 read-performance be similar?
Date: Mon, 20 Aug 2007 09:41:21 +0200
Message-ID: <735D322AED9CD711BE53000476917CD002971D17@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok,

So reading out TWO streams serial from each disk would give the speedup=
,
wouldn't it?
The driver would just have to cache the four(6,8,..) streams until they=
 are
merged?
So the driver has just to cache two streams per disk and all would be
perfect...?

Just as proposal for the future md-raid-driver releases ;))

=46lorian

> -----Urspr=FCngliche Nachricht-----
> Von: Mario 'BitKoenig' Holbe [mailto:Mario.Holbe@TU-Ilmenau.DE]=20
> Gesendet: Montag, 13. August 2007 16:50
> An: linux-raid@vger.kernel.org
> Betreff: Re: Mustn't be RAID 1 and 0 read-performance be similar?
>=20
> Rustedt, Florian <florian.rustedt@smartnet.de> wrote:
> > If the speed on RAID 0 is based on reading out in parallel, then it=
=20
> > must be the same on RAID 1, mustn't it?
> > On RAID 1, it is possible, to read two blocks in parallel=20
> to speed up, too.
>=20
> It's not that simple.
> On RAID0 you can read one single stream of data from all of=20
> the disks in
> parallel: you read one stream from each disk with each stream=20
> containing completely different data and merge them together=20
> to get the original stream. On RAID1 you can only read=20
> exactly the same stream from all of the disks. Thus, RAID1=20
> cannot provide RAID0's speed-up for a single stream.
> However, if you read multiple streams parallel, RAID1 can do=20
> better than RAID0 because you can read stream1 from disk1,=20
> stream2 from disk2 etc.
> Using RAID0, this speed-up can only be achieved for streams=20
> <=3D chunk size.
>=20
>=20
> regards
>    Mario
***********************************************************************=
***********************
IMPORTANT: The contents of this email and any attachments are confident=
ial. They are intended for the=20
named recipient(s) only.
If you have received this email in error, please notify the system mana=
ger or the sender immediately and do=20
not disclose the contents to anyone or make copies thereof.
*** eSafe scanned this email for viruses, vandals, and malicious conten=
t. ***
***********************************************************************=
***********************

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
