From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm raid5 dropped 2 disks
Date: Sat, 6 Feb 2016 11:46:51 +0000
Message-ID: <56B5DD2B.50307@youngman.org.uk>
References: <56B479DD.7070600@gmx.de> <56B5D103.8070908@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B5D103.8070908@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Andr=c3=a9_Teichert?= <andre_teichert@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/02/16 10:54, Andr=C3=A9 Teichert wrote:
> glad it worked. Will save lsdrv and hope never to use it. Create new
> backupplan!

Please DO use lsdrv. EVERY time you create or change the config of an
array, run it and save the info somewhere safe.

Neil has just stepped down as maintainer and Phil is now "one of the
team", he wrote that utility specifically to help in recovering crashed
arrays. If anything goes wrong and you've got that data to hand, it'll
make their lives much easier to help you.

Cheers,
Wol
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
