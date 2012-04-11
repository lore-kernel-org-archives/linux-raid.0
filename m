From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: Failed Array Rebuild advice Please
Date: Tue, 10 Apr 2012 21:14:07 -0700 (PDT)
Message-ID: <1334117647.68845.YahooMailNeo@web125505.mail.ne1.yahoo.com>
References: <1334097164.41181.YahooMailNeo@web125506.mail.ne1.yahoo.com> <20120411090219.78392784@notabene.brown>
Reply-To: jahammonds prost <gmitch64@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120411090219.78392784@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

One other question as the badblocks progresses.
=A0
>=A0 It will then recovery both devices in parallel.

How many additional devices can be done at the same time? I presume tha=
t I am going to have to=A0replace the 2 failed devices before I try and=
 grow the array by adding 3 additional drives? I so, how many=A0additio=
nal drives can be rebuilt concurrently with a grow? Could I add 5 devic=
es and not see too much of a performance hit? Or would it be more sensi=
ble to add them one at a time?


YP
=A0
----- Original Message -----
=46rom: NeilBrown <neilb@suse.de>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
Sent: Tuesday, 10 April 2012, 19:02
Subject: Re: Failed Array Rebuild advice Please

On Tue, 10 Apr 2012 15:32:44 -0700 (PDT) jahammonds prost
<gmitch64@yahoo.com> wrote:


> Since I know I did nothing with the temp one drive array when the ser=
ver was booted (and I don't think that the md code did anything either?=
?) would it be safe to=20
> =A0
> mdadm --assemble /dev/md0 /dev/sd[a-c]1 /dev/sd[e-h]1 /dev/sd[j-l]1 /=
dev/sd[n-p]1 --force
> =A0
> to let the array come back up and get it running?

Yes.=A0  Though you don't need to exclude the oldest devices.=A0 mdadm =
will
figure out which ones to use and which ones to avoid.


> =A0
> What would then be the correct sequence to replace the 2 failed drive=
s (sdd1 and sdm1) and get the array running fully again?

If you trust that sdd and sdm really are working now, you can

mdadm /dev/md0 --add /dev/sdd1 /dev/sdm1

This will probably start rebuilding just one of the devices. You can ch=
eck
with
=A0  mdadm -D /dev/md0
which will report "spare building" against one or more devices.
If it is only rebuilding one of them, then

=A0 echo idle > /sys/block/md0/md/sync_action

will cause it to stop and restart the recovery.=A0 It will then recover=
y both
devices in parallel.

(Next version of mdadm will do this automatically).

NeilBrown


> =A0
> =A0
> Thanks for your help.
> =A0
> =A0
> YP.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
