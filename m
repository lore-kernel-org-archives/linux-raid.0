From: Vincent Pelletier <plr.vincent@gmail.com>
Subject: Re: Spin down
Date: Mon, 5 Dec 2011 08:49:03 +0100
Message-ID: <CAF78GY0u89KvZhEZQ64GxWeDpBCT6cdAJ+xaGm=z7O_2gKTYTA@mail.gmail.com>
References: <CAF78GY0YdJ0c0WWpyDnnzitAec_7VZZnEsP_n_UHuec5JmVAng@mail.gmail.com>
	<20111205171115.044b1705@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111205171115.044b1705@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 5, 2011 at 7:11 AM, NeilBrown <neilb@suse.de> wrote:
> 5 seconds suggests a bitmap update. =A0Do you have an internal bitmap=
?

I don't, but I enabled it on those arrays before with default delay.
I then removed it when I suspected (with help of block_dump) it to
cause spin-ups, and I noticed an improvement. Recently, the machine
was restarted (once on 3.0 kernel, and again to update to 3.1), and
after both restarts those 5s periodic writes occurred.

> Then try adding it back with a longer delay
> =A0mdadm --grow /dev/md0 --bitmap=3Dinternal --delay=3D60

Adding bitmaps on both arrays (md0 and md1), 5s periodic writes disappe=
ar.
Removing bitmaps seems to preserve the improvement.

Could the delay setting have survived on-disk and be used when
initializing the array, but cleared when mdadm later disables bitmap
usage ?

> What kernel version are you running?

3.1.4, according to dpkg:
ii  linux-image-3.1.0-1-amd64                   3.1.4-1
                     Linux 3.1 for 64-bit PCs

Regards,
--=20
Vincent Pelletier
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
