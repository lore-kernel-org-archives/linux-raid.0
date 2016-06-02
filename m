From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: raid 5 crashed
Date: Thu, 2 Jun 2016 17:27:24 +0200
Message-ID: <20160602152723.GA4917@metamorpher.de>
References: <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org>
 <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
 <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com>
 <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com>
 <574F00F5.80801@youngman.org.uk>
 <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com>
 <57503C3F.6020005@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57503C3F.6020005@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Edward Kuns <eddie.kuns@gmail.com>, Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On Thu, Jun 02, 2016 at 03:01:35PM +0100, Wols Lists wrote:
> If you have 3 x 4TB desktop drives in an array, then the spec
> says you should expect, and be able to deal with, an error EVERY time
> you scan the array.

It doesn't happen in practice, though. (Thank god.)

There was a paper about disk failures that said URE was simply not useful. 
(Empirical Measurements of Disk Failure Rates).

There's this ZDnet article that declared RAID5 dead in 2009 but it still 
works fine for me.

I just ignore the URE spec entirely.
(Until someone can prove that it actually matters.)

IMHO the main reason people notice disk failures during rebuilds, is that 
they never ever tested their disks for read errors before. You should do 
so regularly.

A long SMART self-test takes ages on a large disk, on a busy server with 
today's disk sizes it can take days, which is why people avoid running 
them (the other reason is lazyness).

However, SMART also supports selective self-tests; so you can run a 
relatively short test every day and cover the entire disk over time.
You can schedule these partial tests at night when server load is lowest.

I think mdadm can also do a selective RAID check by fiddling with some 
variables in /proc but there is no obvious way of doing so via 
the userspace program.

Regards
Andreas Klauer
