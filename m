From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Thu, 21 Feb 2013 18:41:12 +0100
Message-ID: <51265C38.6000400@hesbynett.no>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5125B8E5.5000502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/02/13 07:04, Stan Hoeppner wrote:
> FYI for future Linux server deployments, it's very rare that a server
> workload will run better with HT enabled.  In fact they most often
> perform quite a bit worse with HT enabled.  The ones that may perform
> better are those such as IMAP servers with hundreds or thousands of user
> processes, most sitting idle, or blocking on IO.  For a block IO server
> with very few active processes, and processes that need all possible CPU
> bandwidth for short intervals (mdraid5 write thread), HT reduces CPU
> bandwidth due to switching between two hardware threads on one core.
>
> Note that Intel abandoned HT with the 'core' series of CPUs, and
> reintroduced it with the Nehalem series.  AMD has never implemented HT
> (SMT) it its CPUs.  And if you recall Opterons beat the stuffing out of
> Xeons for many, many years.
>

It is worth noting here that there are very different implementations of 
HT.  Intel's first HT processors had severe problems with the cost of 
context switches, and most loads performed better with HT disabled.  But 
these days are long gone - the current HT processors are much more 
effective.  On loads where there is a fair amount of processing going 
on, then HT can help significantly.  If you are IO or memory bound, of 
course, then HT will not help at all - and even the modern cheaper 
context switches are not free, and may reduce the overall performance.

Also remember that when HT was first introduced in x86 cpus, OS's (Linux 
and other unmentionable OS's) were not optimised for them - they treated 
the fake cores like real ones.  These days Linux makes a distinction and 
uses the fake cores appropriately.

HT may not be of help in a pure file server setup, but in many other 
server applications such as web servers (and IMAP, as you mentioned), HT 
is a huge benefit.  It is not coincidence that the big server cpu 
architectures (MIPS, Power, SPARC) all use 2 or even 4 time SMT.

I have no numbers of my own to back this up - but I would certainly not 
consider disabling HT on a server without very concrete reasoning.

(I too was a great fan of AMD, and used them almost exclusively until 
the Core 2 architecture from Intel.  And while I am glad that Intel have 
made very nice chips in recent years, I think it is a shame that they 
did so using ideas copied directly from AMD - and AMD can no longer 
seriously compete.)

