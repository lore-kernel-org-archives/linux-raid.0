From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: raid 5 crashed
Date: Fri, 3 Jun 2016 09:05:11 +0800
Message-ID: <40b1ed1e-b0bd-a496-b5c8-6ad1f370b3ee@fnarfbargle.com>
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
 <57503C3F.6020005@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57503C3F.6020005@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Edward Kuns <eddie.kuns@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 02/06/16 22:01, Wols Lists wrote:
> On 02/06/16 00:15, Brad Campbell wrote:
>> People keep saying that. I've never encountered it. I suspect it's just
>> not the problem that the hysterical ranting makes it out to be (either
>> that or the pile of cheap and nasty drives I have here are model citizens).
>> I've *never* seen a read error unless the drive was in trouble, and that
>> includes running dd reads in a loop over multiple days continuously.
>> If it were that bad I'd see drives failing SMART long tests routinely
>> also, and that does not happen either.
>
> Note I didn't say you *will* see an error. BUT. If I recall correctly,
> the specs say that one read error per 10TB read is acceptable for a
> desktop drive that is designated healthy. In other words, if a 4TB drive
> throws an error every third pass, then according to the spec it's a
> perfectly healthy drive.
>
> Yes. We know that most drives are far better than spec, and if it
> degrades to spec then it's probably heading for failure, but the fact
> remains. If you have 3 x 4TB desktop drives in an array, then the spec
> says you should expect, and be able to deal with, an error EVERY time
> you scan the array.

No, it really doesn't. Those URE figures say <' 1 in' 10^14, not '= 1' 
in 10^14. So that's a statistical worst case rather than a "this is what 
you should expect". In addition, it's not a linear extrapolation, it's a 
probability.

By that logic I should "expect" to roll a 6 at least once every 6 dice 
rolls.

You can't extrapolate statistical figures like that. Just the same as 
you can't calculate drive failures from MTBF figures.

Just perform regular read tests on all drives and periodic array scrubs 
and you'll be much better off.

I've never had a reported URE on any of my arrays with SAS drvies, most 
have reallocated sectors. They perform background reads periodically and 
auto-reallocate anything that is looking dodgy.

SATA drives don't do that, but we can manage that externally with long 
SMART tests and array scrubs to force rewrite/reallocation.

Just don't go trying to extrapolate from manufacturers probability data. 
There are plenty of garbage web pages littered around the net where 
"experts" do that, leading to 'hysterical ranting' about how the world 
is ending and RAID5 is the devil. Sure RAID5 can be an issue when 
dealing with a catastrophic drive failure requiring a rebuild if you 
don't look after your drives, and I use and prefer RAID6 to mitigate 
that, but it's not the end of the world.


Now, on an interesting, related and completely different note. To get 
back to the concept of using dd or dd_rescue, I had a thought last night 
and I've never seen it mentioned anywhere.

When you clone a dud drive using dd_rescue, it creates a bad block log.

The reason we don't like doing this is because when you put the 
replacement drive back into the array, md does not see the errors and 
will happily return zero data when it reads any sector that was bad on 
the old drive.

hdparm has a neat feature called --make-bad-sector. It uses a feature of 
the ATA protocol to write a sector that contains an invalid CRC, so the 
drive returns an error when you try and read it. The sector is restored 
by a normal re-write, so no reallocation or permanent damage takes place.

If we took the bad block list from the dd_rescue, and fed it to hdparm 
to create bad sectors in all those locations on the cloned disk, md 
would get a bad sector on read and attempt a recovery rather than 
returning zero, This would "in theory" cause a re-write of good data 
back to that disk and minimise the chance of data loss.

This might be a useful "last ditch" recovery method to allow you to 
bring up an array with a cloned disk and minimise data loss. On the 
other hand, lets say you are using it to bring up a RAID 5 with 2 failed 
disks. One completely dead and one that you managed to clone most of. 
When you extract the data from the running and degraded array, md will 
pass the read error up the stack when it encounters the bad sectors, 
allowing your copy or rsync session to log which files are affected as 
you backup the remaining contents rather than just return silently 
corrupted files.


