From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: AWFUL reshape speed with raid5.
Date: Wed, 30 Jul 2008 11:31:46 -0500
Message-ID: <cccedfc60807300931g5a05b197j38022a024fa1f0e@mail.gmail.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
	 <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
	 <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com>
	 <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
	 <48909578.9020307@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48909578.9020307@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 30, 2008 at 11:23 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> Jon Nelson wrote:
>> 2. If no I/O is taking place, why does it take so long? [ NOTE: I/O
>> must be taking place but why doesn't vmstat show it? ]
>>
>
> vmstat doesn't tell you enough, you need a tool to show per-device and
> per-partition io, which will give you what you need. I can't put a finger on
> the one I wrote, but there are others.

I gave dstat a try (actually, I rather prefer dstat over vmstat...):

This is right before, during, and after the --grow operation.

--dsk/sdb-----dsk/sdc-----dsk/sdd-----dsk/sde----dsk/total-
 read  writ: read  writ: read  writ: read  writ: read  writ
   0    44k:   0    24k:   0    24k:   0     0 :   0   184k
   0     0 :   0     0 :   0     0 :   0     0 :   0     0
   0    24k:   0     0 :   0     0 :   0     0 :   0    48k
  32M   14k:  32M 2048B:  32M 2048B:   0     0 : 191M   36k
  63M    0 :  63M    0 :  63M    0 :   0     0 : 377M    0
  65M    0 :  65M    0 :  65M    0 :   0     0 : 391M    0
  72M    0 :  73M    0 :  73M    0 :   0     0 : 437M    0
  74M    0 :  73M    0 :  74M    0 :   0     0 : 441M    0
  70M   48k:  70M    0 :  70M    0 :   0     0 : 419M   96k
  61M   44k:  61M   16k:  62M   32k:   0     0 : 368M  184k
  71M    0 :  72M    0 :  71M    0 :   0     0 : 429M    0
  74M    0 :  73M    0 :  73M    0 :   0     0 : 439M    0
  73M    0 :  73M    0 :  73M    0 :   0     0 : 439M    0
  71M   20k:  71M    0 :  71M    0 :   0     0 : 426M   40k
  72M    0 :  72M    0 :  73M    0 :   0     0 : 434M    0
  73M    0 :  74M    0 :  73M    0 :   0     0 : 442M    0
  60M   40k:  59M   16k:  59M   28k:   0     0 : 356M  168k
  73M    0 :  73M    0 :  73M    0 :   0     0 : 438M    0
  70M   24k:  69M    0 :  70M    0 :   0     0 : 418M   48k
  72M    0 :  71M    0 :  72M    0 :   0     0 : 430M    0
  73M    0 :  73M    0 :  73M    0 :   0     0 : 437M    0
  71M    0 :  71M    0 :  71M    0 :   0     0 : 427M    0
  73M    0 :  73M    0 :  73M    0 :   0     0 : 437M    0
  71M   24k:  71M    0 :  71M    0 :   0     0 : 428M   48k
  72M    0 :  72M    0 :  72M    0 :   0     0 : 432M    0
  73M    0 :  73M    0 :  73M    0 :   0     0 : 437M    0
  71M 4096B:  70M    0 :  70M    0 :   0     0 : 422M 8192B
  58M    0 :  58M    0 :  58M    0 :   0     0 : 350M    0
  59M   24k:  60M    0 :  59M    0 :   0     0 : 357M   48k
  74M    0 :  73M    0 :  74M    0 :   0     0 : 441M    0
  19M 8192B:  19M 8192B:  19M 4096B:   0     0 : 114M   40k
   0     0 :   0     0 :   0     0 :   0     0 :   0     0
   0     0 :   0     0 :   0     0 :   0     0 :   0     0
   0   160k:   0    16k:   0    20k:   0     0 :   0   392k

So. Clearly, lots of I/O. 440MB/s total.  Almost entirely reads.


Question:  to --grow --size the array, clearly we see lots of reads.
Why aren't we seeing any (meaningful) writes? If there are no writes,
then what purpose do the reads serve?
