From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 21:16:31 -0500
Message-ID: <6d5bedd80501031816eb8f296@mail.gmail.com>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es>
	 <l1nna2-e9i.ln1@news.it.uc3m.es>
	 <200501031846.42950.maarten@ultratux.net>
	 <200501032052.21459.maarten@ultratux.net>
	 <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es>
	 <16857.55609.534526.297577@cse.unsw.edu.au>
	 <jh4pa2-pi.ln1@news.it.uc3m.es>
	 <16857.64086.362458.177296@cse.unsw.edu.au>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16857.64086.362458.177296@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I are confused...

Which perhaps should be a lesson to a slightly knowlegeable user not
to read a thread like this.

But having given myself a headache trying to figure this all out, I
guess I'll just go ahead and ask directly.

I've setup a RAID-5 array using two internal 250 Gig HDs and two
external 250 Gig HDs through a USB-2 interface. Each of the externals
is on it's own card, and the internals are on seperate IDE channels.

I "thought" I was doing a good thing by doing all of this and then
setting them up using an ext3 filesystem.

From the reading on here I'm not clear if I should have specified
something besides whatever ext3 does by default when you set it up,
and if so if it's something I can still do without having to redo
everything. Something I'd rather not do to be honest.

Thanks in advance,
Ewan
---
http://a1.blogspot.com - commentary since 2002
