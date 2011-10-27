From: David Brown <david@westcontrol.com>
Subject: Re: with raid-6 any writes access all disks
Date: Thu, 27 Oct 2011 11:29:55 +0200
Message-ID: <4EA92493.1060107@westcontrol.com>
References: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com> <20111027082331.01e1fc7a@notabene.brown> <4EA889FF.90002@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EA889FF.90002@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Chris Pearson <kermit4@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/10/2011 00:30, H. Peter Anvin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 10/26/2011 11:23 PM, NeilBrown wrote:
>> On Wed, 26 Oct 2011 16:01:19 -0500 Chris Pearson
>> <kermit4@gmail.com>  wrote:
>>
>>> In 2.6.39.1, any writes to a raid-6 array cause all disks to be
>>> accessed.  Though I don't understand the math behind raid-6, I
>>> have tested on LSI cards that it is possible to only access 3
>>> disks.
>>
>> You are correct.  md/raid6 doesn't do the required maths.
>>
>> i.e.  it always adds all data together to calculate the parity. It
>> never subtracts old data from the parity, then add new data.
>>
>> This was a decision made by the original implementer (hpa) and
>> no-one has offered code to change it.
>>
>> (yes, I review and accept patches :-)
>>
>
> This was based on benchmarks at the time that indicated that
> performance suffered more than it helped.  However, since then CPUs
> have gotten much faster whereas disks haven't.  There was also the
> issue of getting something working reliably first.
>
> Getting a set of hardware acceleration routines for arbitrary GF
> multiplies (as is possible with SSSE3) might change that tradeoff
> dramatically.
>
> 	-hpa
>

I can add a little of the theory here (HPA knows it, of course, but 
others might not).  I'm not well versed in the implementation, however.


With RAID5, writes to a single data disk are handled by RMW code, 
writing to the data disk and the parity disk.  The parity is calculated as:

P = D0 + D1 + D2 + .. + Dn

So if Di is to be written, you can use:

P_new = P_old - Di_old + Di_new

Since "-" is the same as "+" (in raid calculations over GF(2^8)), and is 
just "xor", that's easy to calculate.

As far as I know, the RAID5 code implements this as a special case.  If 
more than one data disk in the stripe needs to be changed, the whole 
stripe is re-written.

It would be possible to do RMW writes for more than one data disk 
without writing the whole stripe, but I suspect the overall speed gains 
would be small - I can imagine that small (single disk) writes happen a 
lot, but writes that affect more than one data disk without affecting 
most of the stripe would be rarer.



RAID6 is more complicated.  The parity calculations are:

P = D0 + D1 + D2 + .. + Dn
Q = D0 + 2.D1 + 2^2.D2 + .. + 2^(n-1).Dn

(All adds, multiplies and powers being done over GF(2^8).)


If you want to re-write Di, you have to calculate:

P_new = P_old - Di_old + Di_new
Q_new = Q_old - 2^(i-1).Di_old + 2^(i-1).Di_new

The P_new calculation is the same as for RAID5.

Q_new can be simplified to:

Q_new = Q_old + 2^(i-1) . (Di_old + Di_new)


"Multiplying" by 2 is relatively speaking quite time-consuming in 
GF(2^8).  "Multiplying" by 2^(i-1) can be done by either pre-calculating 
a multiply table, or using a loop to repeatedly multiply by 2.

When RAID6 was originally implemented in md, cpus were slower and disks 
faster (relatively speaking).  And of course simple, correct code is far 
more important than faster, riskier code.  Because of the way the 
standard Q calculation is implemented (using Horner's rule), the 
re-calculation of the whole of Q doesn't take much longer than the 
worst-case Q_new calculation (when it is the last disk changed), once 
you have the other disks read in (which takes disk time and real time, 
but not cpu time).  Thus the choice was to always re-write the whole stripe.

However, since then, we have faster cpus, slower disks (relatively 
speaking), more disks in arrays, more SIMD cpu instructions, and better 
compilers.  This means the balance has changed, and implementing RMW in 
RAID6 would almost certainly speed up small writes, as well as reducing 
the wear on the disks.

I don't know what compiler versions are typically used to compile the 
kernel, but from gcc 4.4 onwards there is a "target" function attribute 
that can be used to change the target cpu for a function.  What this 
means is that the C code can be written once, and multiple versions of 
it can be compiled with features such as "sse", "see4", "altivec", 
"neon", etc.  And newer versions of the compiler are getting better at 
using these cpu features automatically.  It should therefore be 
practical to get high-speed code suited to the particular cpu you are 
running on, without needing hand-written SSE/Altivec assembly code. 
That would save a lot of time and effort on writing, testing and 
maintenance.


That's the theory, anyway - in case anyone has the time and ability to 
implement it!







