From: "John Stoffel" <john@stoffel.org>
Subject: Re: Big trouble during reassemble a Raid5
Date: Mon, 29 Dec 2014 13:32:04 -0500
Message-ID: <21665.40484.909891.197506@quad.stoffel.home>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
	<938521225.11264152.1419768981146.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <938521225.11264152.1419768981146.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: sylvain.depuille@laposte.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sylvain,

I would recommend that you buy a replacement disk for the one
throwing errors and then run dd_rescue to copy as much data from the
dying disk to the replacement.  Then, and only then, do you try to
reassemble the array with the --force option.

That disk is dying, and dying quickly.

Can you also post the output of 

mdadm -E /dev/sd[bcde]1 for each disk, even the dying one, so we can
look at the counts and give you some more advice.  Also, the output of
the mdadm --assemble --force /dev/md2 /dev/sd[bcde]1 would also be
good.  The more info the better.

Good luck!
John


sylvain> i'm sorry to ask this questions but the raid 5 with 4 disk is
sylvain> in big trouble during re-assemble. 2 disks are out of order.
sylvain> I have change a disk of the raid 5 (sde) to growing the raid.
sylvain> But a second disk (sdc) have too many bad sector during the
sylvain> re-assemble, and shutdown the re-assemble.  "mdadm --assemble
sylvain> --force /dev/md2 /dev/sd[bcde]1" I have try to correct bad
sylvain> sectors with badblocks, but it's finished by no more spare
sylvain> sectors and the disk still have some bad sector.  badblocks
sylvain> -b 512 -o badblocks-sdc.txt -v -n /dev/sdc 1140170000
sylvain> 1140169336 1140169400 1140169401 1140169402 1140169403
sylvain> 1140169404 1140169405 1140169406 1140169407 1140169416
sylvain> 1140169417 1140169418 1140169419 1140169420 1140169421
sylvain> 1140169422 1140169423


sylvain> For information the mdadm examine return : cat mdadm-exam.txt
sylvain> /dev/sdb: MBR Magic : aa55 Partition[0] : 1953523120 sectors
sylvain> at 2048 (type fd) /dev/sdc: MBR Magic : aa55 Partition[0] :
sylvain> 1953520002 sectors at 63 (type fd) /dev/sdd: MBR Magic : aa55
sylvain> Partition[0] : 1953520002 sectors at 63 (type fd) /dev/sde:
sylvain> MBR Magic : aa55 Partition[0] : 4294965247 sectors at 2048
sylvain> (type fd)

sylvain> I have 2 way to solve the issue.  The first, is to have
sylvain> special command to pass bad sector during re-assemble as
sylvain> "mdadm --assemble --force /dev/md2 /dev/sd[bcde]1" The second
sylvain> is change the disk sde with the old good one, but some datas
sylvain> have been changed on the raid since i have remove it. But
sylvain> these datas are not important. It's only logs and history
sylvain> activity.

sylvain> What can i do to recover a maximum datas without too many
sylvain> risk?

sylvain> Thank's in advance Best Regards
sylvain> ---------------------------------- Sylvain Depuille (in
sylvain> trouble)

sylvain> sylvain.depuille@laposte.net -- To unsubscribe from this
sylvain> list: send the line "unsubscribe linux-raid" in the body of a
sylvain> message to majordomo@vger.kernel.org More majordomo info at
sylvain> http://vger.kernel.org/majordomo-info.html
