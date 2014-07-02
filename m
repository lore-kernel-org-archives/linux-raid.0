From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 15:14:06 +0100
Message-ID: <20140702151406.Horde.HZoGSPYRo99TtBOu1q6B-GA@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702204502.6b538fa8@notabene.brown>
 <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
 <20140702152429.742a3e8ea8bd100f5b3bae1f@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702152429.742a3e8ea8bd100f5b3bae1f@bbaw.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?utf-8?b?VMOkdWJlcg==?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Lars,

the output of those commands:

root@nas3:/# cat /sys/block/sdb/queue/physical_block_size
4096
root@nas3:/# cat /sys/block/md0/queue/physical_block_size
4096
root@nas3:/#

The strange thing here is that dmesg is not poluted with sata errors =20
like it is usual when a hard disk has bad sectors or some other =20
hardware problem. the only thing in dmesg that hints to why reading =20
the md volume fails are from dm itself.

Cheers
Pedro


Citando Lars T=C3=A4uber
> Hi Pedro,
>
> maybe an issue with the logical/physical blocksize?
> What tell these commands:
>
> cat /sys/block/sdb/queue/physical_block_size
> cat /sys/block/md0/queue/physical_block_size
>
> Seagate says there are 4096 bytes/sector on this devices.
>
> Lars



_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
