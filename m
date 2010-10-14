From: Paul Clements <paul.clements@us.sios.com>
Subject: Re: bitmap questions
Date: Thu, 14 Oct 2010 01:02:46 -0400
Message-ID: <AANLkTikBAi=NO-uzkvtzwYsgLSf44KuA1VmvXj3d708_@mail.gmail.com>
References: <201010131824.53363.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201010131824.53363.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 13, 2010 at 12:24 PM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:

> I have a question on how bitmap works and what's shown in /proc/mdsta=
t, for
> example:
>
> md2 : active raid10 sdc3[0] sdd3[3] sdb3[2] sda3[1]
> =A0 =A0 =A060002560 blocks 64K chunks 2 near-copies [4/4] [UUUU]
> =A0 =A0 =A0bitmap: 1/1 pages [4KB], 65536KB chunk
>
> - 1 bitmap for 4096 chunks
>
> - if it shows 0/1 pages [0KB] what does it actually mean?

If it's 0 pages then no resync.
I assume you mean 1/1 ?

> Does that mean that
> in case of resync it will resync _all_ 4096  chunks in that page or o=
nly chunks
> that require that (for example 7 chunks) ?

It only resyncs what is dirty. A page dirty in the in-memory bitmap
does not mean ALL bits are dirty, just that the page is allocated.

--
Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
