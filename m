From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 12:57:47 -0400
Message-ID: <4DF39E8B.6090106@gmail.com>
References: <isp2g2$rf$1@dough.gmane.org> <20110609114954.243e9e22@notabene.brown> <isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org> <4DF20C18.3030604@christoph-d.de> <ist9n7$khq$1@dough.gmane.org> <20110611101312.GA3528@lazy.lzy> <isvkrg$c79$1@dough.gmane.org> <20110611131801.GA2764@lazy.lzy> <isvvhi$2vf$1@dough.gmane.org> <4DF38424.1010500@gmail.com> <it058n$1ju$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <it058n$1ju$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/2011 12:31 PM, David Brown wrote:

> What has changed over the years is that there is no longer such a need
> for manual assembly code to get optimal speed out of the cpu. While

Hmmm ... I've done studies on this using an incredibly simple function 
(Riemann Zeta Function c.f. http://scalability.org/?p=470  ).  The short 
version is that hand optimized SSE2 is ~4x faster (for this case) than 
best optimization of high level code.  Hand optimized assembler is even 
better.

> writing such assembly is fun, it is time-consuming to write and hard to
> maintain, especially for code that must run on so many different platforms.

Yes, it is generally hard to write and maintain.  But it you can get the 
rest of the language semantics out of the way.  If you look at the tests 
that Linux does when it starts up, you can see a fairly wide 
distribution in the performance.

raid5: using function: generic_sse (13356.000 MB/sec)
raid6: int64x1   3507 MB/s
raid6: int64x2   3886 MB/s
raid6: int64x4   3257 MB/s
raid6: int64x8   3054 MB/s
raid6: sse2x1    8347 MB/s
raid6: sse2x2    9695 MB/s
raid6: sse2x4   10972 MB/s

Some of these are hand coded assembly. See 
${KERNEL_SOURCE}/drivers/md/raid6sse2.c and look at the 
raid6_sse24_gen_syndrome code.

Really, to get the best performance out of the system, requires a fairly 
deep understanding of how the processor/memory system operates.  These 
functions do use the SSE registers, but we can have only so many SSE 
operations in flight at once.  These processors can generally have quite 
a few simultaneous operations in flight at once, so a knowledge about 
that, and the mix of operations, and how the interact with the 
instruction scheduler in the hardware, is fairly essential to getting 
good performance.

>
>> We are interested in working on this capability (and more generic
>> capability) as well.
>>
>> Is anyone in particular starting to design/code this? Please let me know.
>>
>
> Well, I am currently trying to write up some of the maths - I started
> the thread because I had been playing around with the maths, and thought
> it should work. I made a brief stab at writing a
> "raid7_int$#_gen_syndrome()" function, but I haven't done any testing
> with it (or even tried to compile it) - first I want to be sure of the
> algorithms.

I've been coding various bits as "pseudocode" using Octave.  Makes 
checking with the built in Galios functions pretty easy.

I haven't looked at the math behind the triple parity syndrome calc yet, 
though I'd imagine someone has, and can write it down.  If someone 
hasn't done that yet, its a good first step.  Then we can code the 
simple version from there with test drivers/cases, and then start 
optimizing the implementation.


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
