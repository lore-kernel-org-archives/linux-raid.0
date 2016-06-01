From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid 5 crashed
Date: Wed, 1 Jun 2016 16:36:21 +0100
Message-ID: <574F00F5.80801@youngman.org.uk>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
 <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com>
 <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Edward Kuns <eddie.kuns@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 01/06/16 05:07, Brad Campbell wrote:
> I have however done a *lot* of data recovery on single drives over the
> years and can absolutely vouch that dd will leave you in tears.

Good to know! I've regularly used dd on drives, but not on ones that
were in trouble (maybe once ...)

But now drives are at the point that you cannot guarantee an error-free
scan even on just one pass, I guess I'll have to make sure I use
ddrescue from now on - I usually just read an (old) drive into a file on
a new larger hard disk, loopmount it, and proceed from there ... never
had any trouble so far ...

Cheers,
Wol
