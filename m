From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: 15 * 180gb in raid5 gives 299.49 GiB ?
Date: Thu, 6 Feb 2003 02:13:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302060211030.6169@ddx.a2000.nu>
References: <Pine.LNX.4.53.0302060059210.6169@ddx.a2000.nu>
 <Pine.LNX.4.53.0302060123150.6169@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302060123150.6169@ddx.a2000.nu>
To: linux-raid@vger.kernel.org, Peter Chubb <peter@chubb.wattle.id.au>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

argh :

tried to compile with this patch
tried on 2.4.20 , 2.4.21-pre1 and 2.4.21-pre4

        /usr/src/linux-2.4.21-pre1/arch/i386/lib/lib.a
/usr/src/linux-2.4.21-pre1/lib/lib.a
/usr/src/linux-2.4.21-pre1/arch/i386/lib/lib.a \
        --end-group \
        -o vmlinux
drivers/scsi/scsidrv.o: In function `ahc_linux_biosparam':
drivers/scsi/scsidrv.o(.text+0xf9c4): undefined reference to `__udivdi3=
'
drivers/scsi/scsidrv.o(.text+0xfa0c): undefined reference to `__udivdi3=
'





On Thu, 6 Feb 2003, Stephan van Hienen wrote:

> hmms found out after posting this msg :
>
> http://www.gelato.unsw.edu.au/patches-index.html
>
>   =B3 =B3 [*] Support for discs bigger than 2TB?  =B3 =B3
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
