From: David Greaves <david@dgreaves.com>
Subject: Re: Change disk problem
Date: Sun, 08 Jun 2008 11:00:15 +0100
Message-ID: <484BADAF.4000605@dgreaves.com>
References: <S1753847AbYFHHWg/20080608072236Z+62@vger.kernel.org> <WorldClient-F200806080958.AA58320509@irisinfo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <WorldClient-F200806080958.AA58320509@irisinfo.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Jon_Lur=E5s?= <jon@irisinfo.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Lur=E5s wrote:
> Hello
>=20
> I got a big problem with replacing disk on Software-RAID.
> Whatever I do it just ends up as a spare disk.
> I guess the problem is that the faulty disk was not removed from the =
RAID.
> We just shut down and replace'd the disk.
> Any idea of how to solve this?

You say 'spare' but I think you mean 'that md/mdadm is ignoring it comp=
letely
(on the grounds that it's not showing literally as a 'spare' in the --d=
etail output.

This is expected behaviour - md does not just randomly grab new disks; =
you have
to use 'mdadm /dev/md0 --add /dev/hdk1' (use the correct component) to =
give md
permission to use the new disk.

Note that you should have partitioned it too (ie 'just shut down and re=
place'
becomes, shut down, replace, partition, mdadm --add )

>=20
>     Number   Major   Minor   RaidDevice State
>        0      56        1        0      active sync   /dev/hdi1
>        1      56       65        1      active sync   /dev/hdj1
>        2       0        0        2      removed
>=20


Look at http://linux-raid.osdl.org/ for more info...

HTH

David

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
