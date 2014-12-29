From: "John Stoffel" <john@stoffel.org>
Subject: Re: =?iso-8859-1?Q?Re=A0:?= Re: Big trouble during reassemble a Raid5
Date: Mon, 29 Dec 2014 15:36:23 -0500
Message-ID: <21665.47943.879001.195325@quad.stoffel.home>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
	<938521225.11264152.1419768981146.JavaMail.zimbra@laposte.net>
	<21665.40484.909891.197506@quad.stoffel.home>
	<164935924.13594562.1419881845418.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <164935924.13594562.1419881845418.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: sylvain.depuille@laposte.net
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


sylvain> Hi john, thanks for your answer!  I have change a 1TB disk to
sylvain> growing the raid with 3TB disk.  if i can re-insert the old
sylvain> 1TB disk in place of 3TB disk, only some log and history are
sylvain> corrupted.  i think that is the best way to relaunch the raid
sylvain> without data loss.  But i dont known how change the timestamp
sylvain> of the one raid disk.  Have you a magic command to change a
sylvain> timestamp of a raid partition, and how known the timestamp of
sylvain> the other disk of the raid?  After' raid relaunch, i can
sylvain> change the burn disk by a 3TB new one.  To do the ddrescue, i
sylvain> have a 2TB disk spare! Its not the same geometry, is it
sylvain> possible?  thanks in advance for your help

Sylvain,

Always glad to help here.  I'm going to try and understand what you
wrote and do my best to reply. =20

Is the 1Tb disk the bad disk?  And if you re-insert it and re-start
the RAID5 array, you only have some minor lost files?  If so, I would
probably just copy all the data off the RAID5 onto the single 3Tb disk
as a quick and dirty backup, then I'd use 'dd_rescue' to copy the bad
1Tb disk onto the new 2Tb disk.

All you would have to do is make a partition on the 2tb disk which is
the same size (or a little bigger) than the partition on the 1tb disk,
then copy the partition over like this:

  ddrescue /dev/sd[BAD DISK LETTER HERE]1 /dev/sd[2TB disk letter]1 \=20
  /tmp/rescue.log

So say the bad disk is sdc, and the good 2tb is sdf, you would do:

  ddrescue /dev/sdc1 /dev/sdf1 /tmp/rescue.log

and let it go.  Then you would assemble the array using the NEW 2tb
disk.  Ideally you would remove the bad 1tb disk from the system when
trying to do this.

But you really do need send us the output of the following commands:

  cat /proc/mdstat=20
  cat /proc/partitions
  mdadm --detail /dev/md# =20

    do the above for the RADI5 array.

  mdadm --examine /dev/sd#1

    for each disk in the RAID5 array.

And we can give you better advice. =20

Good luck!


sylvain> ---------------------------------- Sylvain Depuille
sylvain> sylvain.depuille@laposte.net ----- Mail d'origine ----- De:
sylvain> John Stoffel <john@stoffel.org> =C0: sylvain depuille
sylvain> <sylvain.depuille@laposte.net> Cc: linux-raid@vger.kernel.org
sylvain> Envoy=E9: Mon, 29 Dec 2014 19:32:04 +0100 (CET) Objet: Re: Big
sylvain> trouble during reassemble a Raid5

sylvain> Sylvain, I would recommend that you buy a replacement disk
sylvain> for the one throwing errors and then run dd_rescue to copy as
sylvain> much data from the dying disk to the replacement. Then, and
sylvain> only then, do you try to reassemble the array with the
sylvain> --force option.  That disk is dying, and dying quickly.  Can
sylvain> you also post the output of mdadm -E /dev/sd[bcde]1 for each
sylvain> disk, even the dying one, so we can look at the counts and
sylvain> give you some more advice. Also, the output of the mdadm
sylvain> --assemble --force /dev/md2 /dev/sd[bcde]1 would also be
sylvain> good. The more info the better.  Good luck!  John

sylvain> i'm sorry to ask this questions but the raid 5 with 4 disk is
sylvain> in big trouble during re-assemble. 2 disks are out of order.
sylvain> I have change a disk of the raid 5 (sde) to growing the raid.
sylvain> But a second disk (sdc) have too many bad sector during the
sylvain> re-assemble, and shutdown the re-assemble. "mdadm --assemble
sylvain> --force /dev/md2 /dev/sd[bcde]1" I have try to correct bad
sylvain> sectors with badblocks, but it's finished by no more spare
sylvain> sectors and the disk still have some bad sector. badblocks -b
sylvain> 512 -o badblocks-sdc.txt -v -n /dev/sdc 1140170000 1140169336
sylvain> 1140169400 1140169401 1140169402 1140169403 1140169404
sylvain> 1140169405 1140169406 1140169407 1140169416 1140169417
sylvain> 1140169418 1140169419 1140169420 1140169421 1140169422
sylvain> 1140169423

sylvain> For information the mdadm examine return : cat mdadm-exam.txt
sylvain> /dev/sdb: MBR Magic : aa55 Partition[0] : 1953523120 sectors
sylvain> at 2048 (type fd) /dev/sdc: MBR Magic : aa55 Partition[0] :
sylvain> 1953520002 sectors at 63 (type fd) /dev/sdd: MBR Magic : aa55
sylvain> Partition[0] : 1953520002 sectors at 63 (type fd) /dev/sde:
sylvain> MBR Magic : aa55 Partition[0] : 4294965247 sectors at 2048
sylvain> (type fd) I have 2 way to solve the issue. The first, is to
sylvain> have special command to pass bad sector during re-assemble as
sylvain> "mdadm --assemble --force /dev/md2 /dev/sd[bcde]1" The second
sylvain> is change the disk sde with the old good one, but some datas
sylvain> have been changed on the raid since i have remove it. But
sylvain> these datas are not important. It's only logs and history
sylvain> activity.  What can i do to recover a maximum datas without
sylvain> too many risk?  Thank's in advance Best Regards
sylvain> ---------------------------------- Sylvain Depuille (in
sylvain> trouble) sylvain.depuille@laposte.net -- To unsubscribe from
sylvain> this list: send the line "unsubscribe linux-raid" in the body
sylvain> of a message to majordomo@vger.kernel.org More majordomo info
sylvain> at http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
