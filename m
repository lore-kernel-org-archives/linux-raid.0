From: Vincent Pelletier <plr.vincent@gmail.com>
Subject: Re: Spin down
Date: Tue, 6 Dec 2011 09:21:44 +0100
Message-ID: <201112060921.45058.plr.vincent@gmail.com>
References: <CAF78GY0YdJ0c0WWpyDnnzitAec_7VZZnEsP_n_UHuec5JmVAng@mail.gmail.com> <CAF78GY0u89KvZhEZQ64GxWeDpBCT6cdAJ+xaGm=z7O_2gKTYTA@mail.gmail.com> <20111206153923.203df175@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111206153923.203df175@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, kobras@linux.de
List-Id: linux-raid.ids

Le mardi 06 d=E9cembre 2011 05:39:23, NeilBrown a =E9crit :
> Hmm... I cannot reproduce this which makes it harder.

Rebooting on a CONFIG_DYNAMIC_DEBUG-enabled kernel and ssh'ing soon eno=
ugh, I=20
think I found the culprit: noflushd process.
(cc'ing its author)

<noflushd intro>
noflushd is a nice daemon helping suspending disks by tracking disk *re=
ad*=20
activity. When enough time has passed without reads, it disables automa=
ted=20
flushing (echo 0 > /proc/sys/vm/dirty_writeback_centisecs) and takes ov=
er=20
flushing for individual block devices (only flushing spinning devices).
This way, there is no extra delay in writes when disk spins, and only a=
n=20
explicit flush (or read) will cause disk to spin up.
</noflushd intro>

I enabled block_trace to see if the problem was still here, and there w=
as no=20
activity for 10+ seconds. Then I saw traces for noflushd process, and=20
previously-reported writes started ticking every 5s. 5s is the default =
(at=20
least, on my machine) writeback period, so it's what noflushd uses when=
 taking=20
over per-device flushing.
I stopped noflushd process, and tada, problem solved.

=46WIW, noflushd does individual flushes by opening bock device for wri=
te, and=20
fsync()'ing it.

Sorry for the noise.

Regards,
--=20
Vincent Pelletier
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
