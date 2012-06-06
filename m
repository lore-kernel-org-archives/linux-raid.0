From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 23:53:59 +0100
Message-ID: <20431.57247.76819.834529@tree.ty.sabi.co.UK>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
	<CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
	<CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com>
	<CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com>
	<CA+sTkh6xUbQGLXpNiUHmHZoqPaQUrGgoyyX1EssjpO8g8hVZNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh6xUbQGLXpNiUHmHZoqPaQUrGgoyyX1EssjpO8g8hVZNQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> The reasons are pretty well described in FreeBSD 4.11 vinum's
> manual (which I had been using long before LSR):

  =C2=AB=E2=80=A6 For optimum performance, stripes should be at least 1=
28 kB
  in size: anything smaller will result in a significant increase
  in I/O activity due to mapping of individual requests over
  multiple disks.=C2=BB

That is a really gross generalization, because the aggregate
latency due to lack of arm and platter synchronization among RAID
members for example does not apply to flash SSDs, and has
dramatically different impacts on read vs. write and streaming
vs. randomish access patterns, and single vs. multiple threads
workloads.

The above recommendation applies mostly to reading, streaming,
access patterns by single threaded workloads.

However in those cases the argument is even stronger than it was
in the past: the 'man' page makes example about disks with 6
(six) MB/s transfer rates and 8ms latencies, and current disks
often exceed 100 (one hundred) MB/s, while access times haven't
improved much.

  =C2=ABA good guideline for stripe size is between 256 kB and 512
  kB.=C2=BB

It is very important to note here that "stripe size" in Vinum
means "chunk size" in MD. For many workloads that is too large a
chunk size.

  =C2=ABAvoid powers of 2, however: they tend to cause all superblocks
  to be placed on the first subdisk. =E2=80=A6=C2=BB =E2=80=94 http://g=
oo.gl/sTHxY

> P. S. Alas, LSR doesn't support anything but powers of 2 for
> chunk sizes, but according to Neil Brown, it can be relatively
> easy changed.

Some important Linux filesystems try to align metadata to chunk
boundaries instead, for example 'ext3' with 'stride=3D' and XFS
with 'su=3D'.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
