From: David Brown <david@westcontrol.com>
Subject: Re: with raid-6 any writes access all disks
Date: Thu, 27 Oct 2011 15:05:02 +0200
Message-ID: <4EA956FE.3070504@westcontrol.com>
References: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com> <20111027082331.01e1fc7a@notabene.brown> <4EA889FF.90002@zytor.com> <4EA92493.1060107@westcontrol.com> <4EA94D1F.8080507@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EA94D1F.8080507@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Chris Pearson <kermit4@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/10/2011 14:22, H. Peter Anvin wrote:
> On 10/27/2011 11:29 AM, David Brown wrote:
>>
>> Q_new can be simplified to:
>>
>> Q_new = Q_old + 2^(i-1) . (Di_old + Di_new)
>>
>> "Multiplying" by 2 is relatively speaking quite time-consuming in
>> GF(2^8).  "Multiplying" by 2^(i-1) can be done by either pre-calculating
>> a multiply table, or using a loop to repeatedly multiply by 2.
>>
>
> Multiplying by 2 is cheap.  Multiplying by an arbitrary number is more
> expensive, in the absence of tricks that can be played on specific
> hardware implementations (e.g. SSSE3) as mentioned in my paper.

Of course, it all depends on the comparisons - multiplying by 2 is 
fairly cheap, but still more work than the simple "add" (xor) used in 
RAID5.  But I agree that the looping for arbitrary powers of 2 is much 
more costly.

Perhaps it makes sense to have functions dedicated to multiplying 
particular powers-of-two (over a full block).  The loop overhead will 
dominate for small powers, so these could be split off into individual 
implementations.  For larger powers, a loop would be used.  And for 
still larger powers, a lookup table would be faster.  I don't know where 
the boundaries go for these.

>
>>
>> I don't know what compiler versions are typically used to compile the
>> kernel, but from gcc 4.4 onwards there is a "target" function attribute
>> that can be used to change the target cpu for a function.  What this
>> means is that the C code can be written once, and multiple versions of
>> it can be compiled with features such as "sse", "see4", "altivec",
>> "neon", etc.  And newer versions of the compiler are getting better at
>> using these cpu features automatically.  It should therefore be
>> practical to get high-speed code suited to the particular cpu you are
>> running on, without needing hand-written SSE/Altivec assembly code. That
>> would save a lot of time and effort on writing, testing and maintenance.
>>
>
> Nice in theory; doesn't work in practice in my experience.
>

Where does it go wrong?  Is it the automatic vectorisation with SSE, 
etc., that is still too limited with gcc?  I have done very little work 
with x86/amd64 assembly (most of my experience is with microcontrollers 
rather than "big" processors), so I haven't tried looking at gcc's SSE 
code and comparing it to hand-optimised code.

mvh.,

David




