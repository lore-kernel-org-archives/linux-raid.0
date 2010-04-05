From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Linux Raid performance
Date: Mon, 05 Apr 2010 17:35:35 +0100
Message-ID: <4BBA1157.10409@anonymous.org.uk>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com> 	<l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com> 	<4BB69670.3040303@sauce.co.nz> <4BB7856C.30808@shiftmail.org> 	<4BB79D76.7090206@sauce.co.nz> <4BB8A979.3020502@shiftmail.org> 	<w2j7efa8a7d1004041126id2b84d47k7bd275606712d0e3@mail.gmail.com> 	<k2t5bdc1c8b1004041146uec5162b8x5c95bfda2153ebd@mail.gmail.com> 	<1270416495.25890.3.camel@travelmate.workshop> <j2z5bdc1c8b1004041538mafc2efb5lc03d8d82e29e7b31@mail.gmail.com> <o2h7efa8a7d1004050307wec888a73tc297827a0ea6cf8d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <o2h7efa8a7d1004050307wec888a73tc297827a0ea6cf8d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Learner Study <learner.study@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/04/2010 11:07, Learner Study wrote:
> Hi Mark, all:
> 
> My apologies if I sounded like a pest by asking too many
> questions...

Don't worry about it, but do take care - I'm afraid I was similarly 
sceptical about the email alias you've chosen, and got the impression 
from some of your questions that you might be a kid asking people here 
to do your homework for you, which does happen from time to time.

> Since I don't have access to array of disks, I sought to
> the list to see if I could use the info already out there instead of
> reinventing it...how well suited is linux raid for 10G kind of
> traffic..

If you mean 10G bits per second, or at least enough for a 10GigE 
network, then yes I think it is, as evidenced by people here saying 
they've got up to 1400MB/s, as long as you've got enough really fast SAS 
drives hooked up via high-class SAS interfaces over wide PCI Express 
buses to Xeon CPUs with fast RAM, though none of this is exactly 
commodity-class hardware.

As far as I know, 10G bytes per second is beyond PC hardware at the 
moment, and I have no knowledge or experience of the kinds of hardware 
that could reach those speeds.

You got me thinking about the bottlenecks, though. Just for fun (so you 
can see what an odd idea of fun I have), I just restarted my big storage 
server box (Core 2 Quad 3.2GHz on 1600MHz FSB, dual-channel DDR2-800 
memory, Intel P45/ICH10R motherboard) into memtest86+, and it's telling 
me that my memory bandwidth is 4.5GB/s. That's probably about the limit 
of this architecture, though the newer Core i5/7 chips with dual- and 
triple-channel memory controllers integrated can probably manage more.

Now, if I'm running RAID-5 or 6, and Linux md has to copy every page I 
want to write to disc (therefore read it from RAM and write it back 
again), and then read it again to calculate the parity block(s), then 
the SATA/SAS controllers have to read it, that's at least 4 memory 
operations for every write to disc, which is going to mean there's a 
memory subsystem bottleneck/throttle on this machine of about 
1.125GB/sec. I skipped over the bit where I have to write the parity to 
RAM and also have the SATA/SAS controllers read that to write it to the 
disc, but that's going to make a fairly modest difference, maybe down to 
1GB/sec. Since my CPU can calculate RAID-5 or 6 parity on a single core 
at 8GB/sec, that's not the bottleneck.

And I do understand that I'd be rather optimistic to think my RAM 
bandwidth was as much as 4.5GB/s for much of the time.

Reads should be quicker though :-)

Cheers,

John.
