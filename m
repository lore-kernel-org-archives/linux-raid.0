From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: interesting failure scenario
Date: Mon, 4 Apr 2005 09:22:55 +0200
Message-ID: <62b0912f05040400227dab7428@mail.gmail.com>
References: <4250672D.6080403@tls.msk.ru>
	 <62b0912f050404001813448d3d@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f050404001813448d3d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> I just come across an interesting situation, here's the
> scenario.

 [snip] 
 
> Now we have an interesting situation.  Both superblocks in d1
> and d2 are identical, event counts are the same, both are clean.
> Things wich are different:
>    utime - on d1 it is "more recent" (provided we haven't touched
>      the system clock ofcourse)
>    on d1, d2 is marked as faulty
>    on d2, d1 is marked as faulty.
> 
> Neither of the conditions are checked by mdadm.
> 
> So, mdadm just starts a clean RAID1 array composed of two drives
> with different data on them.  And noone noticies this fact (fsck
> which is reading from one disk goes ok), until some time later when
> some app reports data corruption (reading from another disk); you
> go check what's going on, notice there's no data corruption (reading
> from 1st disk), suspects memory and.. it's quite a long list of
> possible bad stuff which can go on here... ;)
> 
> The above scenario is just a theory, but the theory with some quite
> non-null probability.  Instead of hotplugging the disks, one can do
> a reboot having flaky ide/scsi cables or whatnot, so that disks will
> be detected on/off randomly...
> 
> Probably it is a good idea to test utime too, in additional to event
> counters, in mdadm's Assemble.c (as comments says but code disagrees).

Humn, please don't.
 
I rely on MD assembling arrays if their event counters match but the
utimes don't all the time.  Happens quite often that a controller
fails or something like that and you accidentally loose 2 disks in a
raid5.
 
I still want to be able to force the array to be assembled in these cases.
I'm still on 2.4 btw, don't know if there's a better way to do it in
2.6 than manipulating the event counters.
 
(Thinking about it, it would be perfect if the array would instantly
go into read-only mode whenever it is degraded to a non-redundant
state.  That way there's a higher chance of assembling a working array
afterwards?)
