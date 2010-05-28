From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: md strange sync?
Date: Thu, 27 May 2010 18:35:22 -0700
Message-ID: <AANLkTim1JHeU7j8GbXpsvVHr6DmbUlsXX5QFTmHIVbyP@mail.gmail.com>
References: <609221b5db6a42062f7b353d66e424dd.squirrel@fela.liber4e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <609221b5db6a42062f7b353d66e424dd.squirrel@fela.liber4e.com>
Sender: linux-raid-owner@vger.kernel.org
To: jose nuno neto <jose.neto@liber4e.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 27, 2010 at 5:31 AM, jose nuno neto <jose.neto@liber4e.com>=
 wrote:
> Hi2all
>
> I have RedHat 5.5 ( kernel =A02.6.18-194.el5 ) and 2hard disk with ra=
id1
> with md
>
> I have this setup on several machines, and recently notice this messa=
ges
> in /var/log/messages
>
> Are this normal? Seems a re-sync but happened on several machines..
>
> May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: syncing RAID arra=
y md0
> May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: minimum _guarante=
ed_
> reconstruction speed: 1000 KB/sec/disc.
> May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> reconstruction.
> May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: using 128k window=
,
> over a total of 256896 blocks.
> May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: delaying resync o=
f md1
> until md0 has finished resync (they share one or more physical units)
> May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: md0: sync done.
> May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: syncing RAID arra=
y md1
> May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: minimum _guarante=
ed_
> reconstruction speed: 1000 KB/sec/disc.
> May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> reconstruction.
> May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: using 128k window=
,
> over a total of 8193024 blocks.
> May 23 04:23:41 <kern.info> dc2-x6250-a kernel: md: md1: sync done.
>
>
> thanks for any info
>
> regards
> jose
>
> --
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You probably have an automated scrubbing setup in a cronscript.  This
is a good thing as it prevents silent write-errors from going
un-detected until some other drive fails and you suddenly lack
sufficient good devices for that stripe to recover it.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
