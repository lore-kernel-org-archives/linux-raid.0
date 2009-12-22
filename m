From: "Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com>
Subject: Re: Linux MD RAID 1 read performance tunning
Date: Tue, 22 Dec 2009 19:08:25 +0200
Message-ID: <8e04b5820912220908s233c3bf9yf0fa9ba8deda693b@mail.gmail.com>
References: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
	 <20091222165225.GA2684@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222165225.GA2684@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/12/22 Keld J=C3=B8rn Simonsen <keld@keldix.com>:
> On Tue, Dec 22, 2009 at 06:34:55PM +0200, Ciprian Dorin, Craciun wrot=
e:
>> =C2=A0 =C2=A0 Hello all!
>>
>> =C2=A0 =C2=A0 I've created a 64G RAID 1 matrix from 3 real disks. (I=
 intend to
>> use this as a target for backups.)
>> =C2=A0 =C2=A0 Now while playing around with this array, I've observe=
d that the
>> read performance is quite low because it always reads from the disk =
in
>> the first slot (which happens to be the slowest...)
>>
>> =C2=A0 =C2=A0 So my questions are:
>> =C2=A0 =C2=A0 * is there any way to tell the MD driver to load-balan=
ce the reads
>> between the three disks?
>
> It does not make sense to do distributed reading in raid1 for sequent=
ial
> files. This is because it will not be faster to read from more drives=
,
> as this will only make the reading from one drive skipping blocks on
> that drive. In other words, in the time you use for skipping blocks o=
n
> one drive, you could just as well have read the blocks. So then bette=
r
> just read all the blocks off one drive, and then do other possible IO
> from other drives.

    Aha. It makes sens now. But, does it mean that if I have parallel
IO's (from different read operations) they are going to be distributed
between the disks?


> RAID10 is a modern form of raid1, which can do better distributed
> reading, especially raid10,f2 is good for disks, while raid10,o2 may =
be
> better for SSDs.
>
> Best regards
> Keld

    Unfortunately my setup forces me to use RAID1. (Because any of the
three drives should be usable for a full recovery of the backup data.)
(P.S.: Just to be clear, I'm not using RAID as a backup solution, but
rather a redundancy solution for the backup solution. :) )

    Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
