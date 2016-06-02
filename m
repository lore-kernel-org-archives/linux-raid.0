From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid 5 crashed
Date: Thu, 2 Jun 2016 15:01:35 +0100
Message-ID: <57503C3F.6020005@youngman.org.uk>
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
 <574F00F5.80801@youngman.org.uk>
 <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Edward Kuns <eddie.kuns@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 02/06/16 00:15, Brad Campbell wrote:
> People keep saying that. I've never encountered it. I suspect it's just
> not the problem that the hysterical ranting makes it out to be (either
> that or the pile of cheap and nasty drives I have here are model citizens).
> I've *never* seen a read error unless the drive was in trouble, and that
> includes running dd reads in a loop over multiple days continuously.
> If it were that bad I'd see drives failing SMART long tests routinely
> also, and that does not happen either.

Note I didn't say you *will* see an error. BUT. If I recall correctly,
the specs say that one read error per 10TB read is acceptable for a
desktop drive that is designated healthy. In other words, if a 4TB drive
throws an error every third pass, then according to the spec it's a
perfectly healthy drive.

Yes. We know that most drives are far better than spec, and if it
degrades to spec then it's probably heading for failure, but the fact
remains. If you have 3 x 4TB desktop drives in an array, then the spec
says you should expect, and be able to deal with, an error EVERY time
you scan the array. (Yes, I know I would probably be panicking if I got
even one error, too :-)

Cheers,
Wol
