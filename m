From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: raid 5 crashed
Date: Thu, 2 Jun 2016 07:15:32 +0800
Message-ID: <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <574F00F5.80801@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Edward Kuns <eddie.kuns@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids



On 01/06/16 23:36, Wols Lists wrote:
> On 01/06/16 05:07, Brad Campbell wrote:
>> I have however done a *lot* of data recovery on single drives over the
>> years and can absolutely vouch that dd will leave you in tears.
> Good to know! I've regularly used dd on drives, but not on ones that
> were in trouble (maybe once ...)
>
> But now drives are at the point that you cannot guarantee an error-free
> scan even on just one pass,
People keep saying that. I've never encountered it. I suspect it's just 
not the problem that the hysterical ranting makes it out to be (either 
that or the pile of cheap and nasty drives I have here are model citizens).
I've *never* seen a read error unless the drive was in trouble, and that 
includes running dd reads in a loop over multiple days continuously.
If it were that bad I'd see drives failing SMART long tests routinely 
also, and that does not happen either.

-- 

Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

