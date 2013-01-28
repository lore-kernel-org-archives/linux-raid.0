From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 00:00:31 -0700
Message-ID: <7BE0F80F-4730-41C0-80D0-AFD7996FDB4C@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <5105D0EA.7080100@turmel.org> <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com> <20130128063656.BB93524E481@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130128063656.BB93524E481@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 27, 2013, at 11:36 PM, Wolfgang Denk <wd@denx.de> wrote:

>=20
> No.  These are all 512 byte sector drives.

362732152 comes out to a max of 173GiB of mismatching sectors for a 512=
 byte sector size. In any case, the mistmatch count is not trivial, eve=
n if it's not a lot of sectors relative to the size of the array.

>=20
>> What file system?
>=20
> ext4 on all of these.

And what does fsck.ext4 -f -n get you?


>> Have you done only a check or also a repair, either before or after =
the upgrade? (I'm not suggesting doing a repair now.)
>=20
> I did only a check.  I rebootetd two of the systems, which made the
> mismatch_cnt go back to zero.  Of course I don;t know if this means
> everything is fine now.

No, it's fine when you write check to md/sync_action, and upon completi=
on md/mismatch_cnt is 0.

>=20

>> A check should cause URE's to be fixed, but you don't get a count ag=
ainst them because chunk and parity end up being the same for the check=
 after being fixed.
>>=20
>> Are there any messages in dmesg for the time of the check? I would l=
ike to know what was recorded in dmesg at the time the mismatches were =
found.
>=20
> There is absolutely nothing to be seen in the logs; I also routinely
> monitor the drives for reallocated, offline uncorrectable and pending
> sectors, and nothing can be seen here either.
>=20
> I would like to point out that all these systems have been up an
> running essentially unchanged for many months, even years (OK, the ol=
d
> Maxtor drive based one needs a disk swap every few weeks, but this is
> because the disks have reached EOL). No such problem has been observe=
d
> ever before, but now it happens at the first check operation after
> switching to Fedora 18, simultaneous on all systems =85

Switching to Fedora 18 means many things have changed so it's harder to=
 find out, if software, what's causing it. Is it kernel itself, is it m=
d, is it the HBA driver?


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
