From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Maximum theoretical RAID-0 Speed
Date: Sat, 18 Dec 2004 23:54:24 -0500
Message-ID: <200412190454.iBJ4sT928362@www.watkins-home.com>
References: <1c4.217b364e.2ef65ba7@aol.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1c4.217b364e.2ef65ba7@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To verify that you are not at some bus limit, run bonnie on each RAID5
array, one at a time.  Then run 3 bonnies at the same time, one per RAID5
array.  If all 3 can perform at the same time without slow down, then no
hardware limit has been reached.  Also run top or sar or something to check
the CPU load during the tests.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of AndyLiebman@aol.com
Sent: Saturday, December 18, 2004 11:21 PM
To: linux-raid@vger.kernel.org
Subject: Maximum theoretical RAID-0 Speed

I'm wondering if anyone on this list can shed some light on a question that 
pertains to the maximum theoretical read speed for the RAIDS on my Linux
box, 
and whether I have reached it. My guess is, there are about 2 people in the 
world who possibly understand this. Linus Torvolds, perhaps. And maybe
somebody 
else. But I'll give this list a try. I've met some pretty sharp people here.


Here's the scenario I have been testing. 

I have a single Xeon 3.06 processor set to use Hyperthreading, 2 GB of RAM
on 
a SuperMicro Motherboard. The motherboard has 4 PCI "bus segments" with a 
total of six expansion slots. There are two PCI-X 133 Mhz slots (each
associated 
with its own PCI bus segment). There is one PCI-X 100 Mhz slot (on ITS own 
segment) and  three PCI-32bit 33/66 Mhz slots (all sharing the same bus
segment). 
Each of the PCI-X 133 Mhz slots also has one of the built-in GigE ports on
it 
(and I put all my other Intel GigE ports on these two bus segments -- 
sometimes I have up to 6 ports in total on my machine). So I leave the 133
Mhz slots 
out of the RAIDS. 

I have 16 or 24 SATA drive bays in my enclosures. 

My basic design is to make Hardware RAID-5 arrays with 3ware 9000 cards and 
Serial ATA drives. Then I make a Software RAID-0 stripe on top of the
Hardware 
RAID-5. Sometimes I work with 8-channel 3ware cards, sometimes with
12-channel 
cards. So far, I have always put the cards (they're 66Mhz cards) in a 
combination of the 3 PCI 33/66 Mhz slots and the one PCI-X 100 Mhz slot. 

So, as I said above,  that means I don't have any drives connected to the
two 
PCI-X 133 slots (or to the segments they correspond to) because that would 
slow down the bus speed for those segments and presumably hurt my network 
performance. 

When I make a single 8-drive array and test it with Bonnie++, I get a write 
speed of about 75 MB/sec and a read speed of about 300 MB/sec. It's the same

whether I put the 3ware card and drives on the PCI 33/66 slots or in the
PCI-X 
100Mhz slot (or in a PCI-X 133 slot for that matter, which I haven't done 
except once for a test). 

When I make a single 12-drive array and do the same test, I get a write
speed 
of about 90 MB/sec, and a read speed of about 375 MB/sec. So, 12-drive
arrays 
are faster than 8 drive arrays. Sensible. 

When I put a software stripe on top of two 8 drive arrays, I get a write 
speed of about 100 MB/sec, and a read speed of about 475-500 MB/sec. So
striping 
two 8-drive arrays gives a significant boost in read performance. Almost
double 
the performance of a single 8-drive array. 

When I put a software stripe on top of three 8 drive arrays, the write speed

goes up to about 150 MB/sec, but the read speed drops a bit from the maximum

-- I get about 450 MB/sec. One explanation for the lower read speed may be
that 
I have two 8 channel cards on the same PCI bus segment, and one 8 channel 
card on its own segment. Maybe there's an imbalance in bandwidth to the
cards. 

When I put a software stripe on top of two 12-drive arrays, the read and 
write speeds is about the same as I get with two 8-drive arrays. So, there's
no 
advantage in striping 8-drive arrays versus 12-drive arrays -- even though
the 
12-drive arrays on their own perform better than the 8-drive arrays on THEIR

own. 

The key point is, I get the best performance (at least as measured by 
Bonnie++) striping two arrays as opposed to striping three arrays. 

By the way, my measurements have been taken with the 2.6.6 kernel -- and
I've 
tested each scenario at least 3 or 4 times and averaged the results. 
Preliminary testing with the 2.6.9 kernel shows about 50 percent higher
write speeds, 
and a slight drop (like 3 or 4 percent) in read speeds. 

My question is, do you think I have reached some sort bandwidth limit with a

read speed of around 500 MB/sec? Could it be that the CPU/RAM/PCI-X buses
just 
can't handle any more data? Or might I be missing some tricks? 

Would having a second CPU or more RAM make any difference (I don't believe 
so, but I'm no expert on this). Would switching to the new Intel 800 Mhz 
frontside bus help (my current CPUs are 533Mhz)? Would if make a difference
if I put 
ALL of my GigE ports on a single PCI-X 133 bus, thus freeing up a third PCI 
bus segment for a 3ware card (allowing me to put three 8-drive arrays each
on 
its own bus segment)? 

I also understand that the new Xeons coming out now have 64-bit extensions 
and run the 64-bit versions of Linux, just as the AMD Opterons do. Would
that 
make a big difference? Would Opterons make a big difference. 

I have played around a lot with the "blockdev --setra" settings. 3ware 
recommends a readahead of 16384 to get the best performance with their
cards. And at 
least with Bonnie++, and the hard drives that I am using, I have found that 
to be true. 

I have also played around with the readahead settings for the Linux Software

RAID-0 array. The default readahead seems to be 1024 per drive. So, for a
two 
drive array, the default gets set to 2048. For three drives the default is 
3072. The default, indeed, gives me the best write speed as measured by
Bonnie++. 
However, for my particular application, I get much better real world 
performance with a higher readahead. (An illustration of the dangers of
tweaking your 
system to get the best results on benchmark tests.) 

This is obviously a very complex problem, and many many factors can
influence 
performance. It WOULD be good to have some sense for the relationship
between 
all the various bottlenecks and variables. 

Looking forward to some thoughtful answers. 

Regards, 
Andy Liebman
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

