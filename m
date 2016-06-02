From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid 5 crashed
Date: Thu, 2 Jun 2016 07:52:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1606020745490.28955@uplift.swm.pp.se>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com> <20160511131524.GA11811@cthulhu.home.robinhill.me.uk> <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com> <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com> <574C8EB9.3070706@youngman.org.uk> <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com> <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com> <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com> <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com> <574F00F5.80801@youngman.org.uk>
 <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2 Jun 2016, Brad Campbell wrote:

> People keep saying that. I've never encountered it. I suspect it's just not

Well, I have had drives that would occasionally throw a read error, but MD 
requires that read error to happen three times before re-writing the 
sector, and that never happened. See earlier discussions I had with Neil 
on the topic. But you're correct, I don't see this on normally functioning 
drives. Swapped out that drive (it didn't have any specific SMART errors 
either) and everything was fine. I don't know what was wrong with it, 
might have been something flying around in there causing spurious 
problems.

> the problem that the hysterical ranting makes it out to be (either that or 
> the pile of cheap and nasty drives I have here are model citizens).
> I've *never* seen a read error unless the drive was in trouble, and that 
> includes running dd reads in a loop over multiple days continuously.
> If it were that bad I'd see drives failing SMART long tests routinely also, 
> and that does not happen either.

I've seen enough read errors that I nowadays only run RAID6, never RAID5. 
I'd also venture to say that considering the amount of people who come on 
the list and who come on the #linux-raid IRC channel with "raid5, 
one-drive-failed, and now I have read error on another drive so my array 
doesn't resync, what should I do?", I'd say this is a real problem. It's 
not however like "if you have a good drive, reading it 5 times will yield 
a read error". The vendor bit error rate specification doesn't work like 
that, so totally agree with you there.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
