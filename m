From: David Brown <david.brown@hesbynett.no>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 16:41:12 +0100
Message-ID: <58D14998.1060601@hesbynett.no>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au> <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com> <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au> <583576ca-a76c-3901-c196-6083791533ee@thelounge.net> <58D126EB.7060707@hesbynett.no> <09f4c794-8b17-05f5-10b7-6a3fa515bfa9@thelounge.net> <58D13598.50403@hesbynett.no> <58D145F9.1080405@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D145F9.1080405@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/17 16:25, Wols Lists wrote:
> On 21/03/17 14:15, David Brown wrote:
>>> for most arrays the disks have a similar age and usage pattern, so when
>>>> the first one fails it becomes likely that it don't take too long for
>>>> another one and so load and recovery time matters
> 
>> False.  There is no reason to suspect that - certainly not to within the
>> hours or day it takes to rebuild your array.  Disk failure pattern shows
>> a peak within the first month or so (failures due to manufacturing or
>> handling), then a very low error rate for a few years, then a gradually
>> increasing rate after that.  There is not a very significant correlation
>> between drive failures within the same system, nor is there a very
>> significant correlation between usage and failures.
> 
> Except your argument and the claim don't match. You're right - disk
> failures follow the pattern you describe. BUT.
> 
> If the array was created from completely new disks, then the usage
> patterns will be very similar, therefore there will be a statistical
> correlation between failures as compared to the population as a whole.
> (Bit like a false DNA match is much higher in an inbred town, than in a
> cosmopolitan city of immigrants.)
> 
> EVEN WORSE. The probability of all the drives coming off the same batch,
> and sharing the same systematic defects, is much much higher. One only
> has to look at the Seagate 3TB Barracuda mess to see a perfect example.
> 
> In other words, IFF your array is built of a bunch of identical drives
> all bought at the same time, the risk of multiple failure is
> significantly higher. How significant that is I don't know, but it is a
> very valid reason for replacing your drives at semi-random intervals.
> 

There /is/ a bit of correlation for early-fail drives coming from the
same batch.  But there is little correlation for normal lifetime drives.

If you roll three dice and sum them, the expected sum will follow a nice
Bell curve distribution.  If you pick another three dice and roll them,
they will follow the same distribution for the expected sum.  But there
is no correlation between the sums.

Similarly, maybe you figure out that there is a 10% chance of the drive
dying in the first month, 10% chance of it dying in the next three
years, then 30% for the fourth year, 40% for the fifth year, and 10%
spread out over the following years.  Multiple drives of the same type
bought at the same time, and run in the same conditions (usage patterns,
heat, humidity, etc.) will have the same expected lifetime curves.  But
if one drive fails in its fourth year, that does not affect the
probability of a second drive also failing in the same year - it is
basically independent.

Now, there will be a little bit of correlation, especially if there are
factors that may significantly affect reliability (such as someone
bumping the server).  But you are still extremely unlikely to find that
after one drive dies, a second drive dies on the same day or so (during
the rebuild) - it is possible, but it is very bad luck.  There is no
statistical basis for thinking it that when one drive dies, it is likely
that another one will die too.

Of course, some types of failures can affect several drives - a
motherboard failure, power supply problem, or similar event could kill
all your disks at the same time.  RAID does not avoid the need for backups!

Also early death failures can be correlated with a bad production batch
- mixing different batches helps reduce the risk of total failure.
Similarly, mixing different disk types reduces the risk of total
failures due to systematic errors such as firmware bugs.


> (Completely off topic :-) but a real-world demonstrable example is
> couples' initials. "Like chooses like" and if you compare a couple's
> first initials against what you would expect from a random sample, there
> is a VERY significant spike in couples that share the same initial.)
> 
> To put it bluntly, if your array consists of disks with near-identical
> characteristics (including manufacturing batch), then your chances of
> random multiple failure are noticeably increased. Is it worth worrying
> about? If you can do something about it, of course!
> 


