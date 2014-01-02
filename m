From: Wolfgang Denk <wd@denx.de>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 23:32:46 +0100
Message-ID: <20140102223246.8DBE538220E@gemini.denx.de>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <52C5A9AA.9090300@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Stan,

In message <52C5A9AA.9090300@hardwarefreak.com> you wrote:
>
> > filesystem blocks and memory pages aren't necessarily 4K, though that
> > is the most common size.
> 
> Yes, they are necessarily 4K in Linux.  Linux only supports page sized
> BIO for consistency across the memory manager and IO subsystems.  Most
> architectures which Linux currently supports have hardware page sizes
> greater than 4K, for instance IA64 supports 4k/8k/16k, even a 4GB page
> size.  But it was decided long ago to stick with 4K for a number of
> reasons, one of these is stated above.  For background on this Google is
> your friend.

Well, you can tune the page size - and if you need no file system
support (like when implementing a RAID controller card) making the
page size exactly the same as the chunk size will allow for some nice
performance optimizations (as you can avoid a lot of large memcpy()
operations).

We did this (some 6 years ago) for the (then AMCC) PPC440SPe
processors; I can't find the old document any longer on APM's web
site, but there is still a copy here ([1]) which shows the effect.

So yes, tuning the system page size can have considerable impact, but
only for special-purpose applications, and when optimising for large
sequential I/O (which appears to be how the RAID controller
manufacturers are testing / optimizing their systems).


Fact is, with a file system on top of the RAID array, and with our
typical work load of many very small files, A RAID6 with chunk size
16k will give much better results that with chunk size 64k - and
anything even bigger will be worse.


[1] ftp://ftp.denx.de/pub/demos/RAID-demo/doc/RAIDinLinux_PB_0529a.pdf

Best regards,

Wolfgang Denk

--
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"The first rule of magic is simple. Don't waste your time waving your
hands and hoping when a rock or a club will do."
                                               - McCloctnik the Lucid
