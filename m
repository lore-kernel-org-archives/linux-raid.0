From: Pedro Teixeira <finas@aeiou.pt>
Subject: Fwd: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 19:39:57 +0100
Message-ID: <20140702193957.Horde.KQOGYPYRo99TtFH9LXIDrpA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ethan.wilson@shiftmail.org
List-Id: linux-raid.ids



Hi Ethan,

    The thing here is that some of the bad blocks ( if not all ) that =20
are giving read errors are not on the bad blocks list. Specifically, =20
the ones that show up when doing a fsck are not on any drive. For =20
these sectors fsck tries to re-write then and md still throws an error =
=20
but they are not added to the list and the disk doesn't drop from the =20
array.

I replaced sdm with a new disk. this was one that had a bunch or bad =20
blocks reported by md, and after finishing the rebuild ( with no =20
errors at all ) the --examine-badblocks still gives me the exact same =20
list of errors. I would expect that replacing the disk by a new one =20
would clear the errors.

as I know the disks are good, is there any way of reseting the bad =20
blocks list without destroying the filesystem?

cheers
Pedro



_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
