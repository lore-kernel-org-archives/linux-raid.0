From: David Brown <david.brown@hesbynett.no>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 18:31:19 +0200
Message-ID: <it058n$1ju$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org> <20110609114954.243e9e22@notabene.brown> <isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org> <4DF20C18.3030604@christoph-d.de> <ist9n7$khq$1@dough.gmane.org> <20110611101312.GA3528@lazy.lzy> <isvkrg$c79$1@dough.gmane.org> <20110611131801.GA2764@lazy.lzy> <isvvhi$2vf$1@dough.gmane.org> <4DF38424.1010500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DF38424.1010500@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/11 17:05, Joe Landman wrote:
> On 06/11/2011 10:53 AM, David Brown wrote:
>
>> Yes - we've already established that the implementation will be
>> possible, and that there are people willing and able to help with it.
>> And I believe that much of the optimisation can be handled by the
>> compiler - gcc has come a long way since raid6 was first implemented in
>> mdraid.
>
> Hmmm ... don't be too overly reliant upon optimization from a compiler
> for your performance. It makes sense to have a well designed (and proven
> correct) algorithm first that is hand optimizable. There are many
> designs which are anathema to performance, and you have to be careful to
> avoid using them in your coding.
>

Absolutely - it's the designer's job to pick a good algorithm, and the 
programmer's job to make a good implementation of it.  But it's the 
compiler's job to turn that into tight object code.  And for code like 
this, the algorithm designer has to work closely with the programmer (or 
be the same person, of course) to pick algorithms that can be 
implemented well.  Similarly, the programmer has to have a good 
understanding of the compiler and be able to understand the generated 
assembly, in order to get the best from the tools.

What has changed over the years is that there is no longer such a need 
for manual assembly code to get optimal speed out of the cpu.  While 
writing such assembly is fun, it is time-consuming to write and hard to 
maintain, especially for code that must run on so many different platforms.

> We are interested in working on this capability (and more generic
> capability) as well.
>
> Is anyone in particular starting to design/code this? Please let me know.
>

Well, I am currently trying to write up some of the maths - I started 
the thread because I had been playing around with the maths, and thought 
it should work.  I made a brief stab at writing a 
"raid7_int$#_gen_syndrome()" function, but I haven't done any testing 
with it (or even tried to compile it) - first I want to be sure of the 
algorithms.


