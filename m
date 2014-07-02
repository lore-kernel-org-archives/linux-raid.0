From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 11:37:05 +0100
Message-ID: <20140702113705.Horde.69xqIvYRo99Ts_DRiQtQwbA@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702155224.072d09ef@natsu>
 <20140702110713.Horde.4jCzQvYRo99Ts9nRe3Oy26A@webmail.aeiou.pt>
 <20140702161109.70843874@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702161109.70843874@natsu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I also did a mdadm --examine-badblocks /dev/sd[bcdefghijklmnopqr] >> =20
raid.b and none of the bad blocks present on the disks are on the =20
range of the ones that are giving out the read error.

Also, is there a way to clear the badblocks list without destroying =20
the filesystem?



_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
