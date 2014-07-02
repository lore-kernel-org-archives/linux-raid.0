From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 19:41:49 +0100
Message-ID: <20140702194149.Horde.0pZGIvYRo99TtFJtt91GOWA@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702204502.6b538fa8@notabene.brown>
 <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
 <21428.13989.101969.396667@quad.stoffel.home>
 <20140702193706.Horde.Q4yuGvYRo99TtFFSw8qw6-A@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702193706.Horde.Q4yuGvYRo99TtFFSw8qw6-A@webmail.aeiou.pt>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



  Hi John,

I can't destroy the fs at the moment.
  The problem is not filesystem related as md throws an error when =20
reading with dd when the filesystem is not mounted.
The controler is flashed with the latest P19 firmware IT mode, meaning =
=20
  that disks are "passed-though". No raid or jbod. Power supply has a =20
singe 12v rail and total output of 800w. Graphics card is a pcie 1x =20
nvidia card.
I have a very similar machine, that has the same case, the same power =20
supply, the same LSI controller in the same mode with the same =20
firmware, same OS, same kernel. Diferences are the motherboard Z87 =20
chipset and i7 cpu, and the hard disks are 16x=A0 4TB seagate HDD's in =
=20
raid6 created the exact same way as this one with mdadm 3.3. I have no =
=20
problems with it.

Cheers
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
