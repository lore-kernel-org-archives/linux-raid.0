From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Thu, 03 Jul 2014 11:39:03 +0100
Message-ID: <20140703113903.Horde.oHFZO-YRo99TtTLHrpYDfrA@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702204502.6b538fa8@notabene.brown>
 <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
 <20140703124046.74272588@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140703124046.74272588@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I ended up understanding the command but if I run it manually it =20
doesn't work. bad_block is cleared but the --examine-badblocks stills =20
shows it. and after stopping/assembling the md volume the bad block =20
shows up again.

root@nas3:~# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
root@nas3:~# mdadm --assemble /dev/md0
mdadm: failed to get exclusive lock on mapfile - continue anyway...
mdadm: /dev/md0 has been started with 16 drives.
root@nas3:~# cat /sys/block/md0/md/dev-sdq/bad_blocks
211996592 128
root@nas3:~# echo "-211996592 128" > /sys/block/md0/md/dev-sdq/bad_bloc=
ks
root@nas3:~# cat /sys/block/md0/md/dev-sdq/bad_blocks
root@nas3:~# mdadm --examine-badblocks /dev/sdq
Bad-blocks on /dev/sdq:
            211996592 for 128 sectors
root@nas3:~#


so "cat /sys/block/md0/md/dev-sdq/bad_blocks" shows now bad blocks, =20
but the --examine-badblocks still lists it.



_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
