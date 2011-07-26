From: David Brown <david.brown@hesbynett.no>
Subject: Re: [md PATCH 17/34] md/raid5: unite handle_stripe_dirtying5 and
 handle_stripe_dirtying6
Date: Tue, 26 Jul 2011 11:40:42 +0200
Message-ID: <j0m22q$rur$1@dough.gmane.org>
References: <20110721022537.6728.90204.stgit@notabene.brown>	<20110721023226.6728.28082.stgit@notabene.brown>	<87tyaepto6.fsf@gmail.com> <20110726115238.63fec583@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110726115238.63fec583@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/07/11 03:52, NeilBrown wrote:
> On Fri, 22 Jul 2011 18:10:33 +0900 Namhyung Kim<namhyung@gmail.com>  wrote:
>
>> NeilBrown<neilb@suse.de>  writes:
>>
>>> RAID6 is only allowed to choose 'reconstruct-write' while RAID5 is
>>> also allow 'read-modify-write'
>>> Apart from this difference, handle_stripe_dirtying[56] are nearly
>>> identical.  So resolve these differences and create just one function.
>>>
>>> Signed-off-by: NeilBrown<neilb@suse.de>
>>
>> Reviewed-by: Namhyung Kim<namhyung@gmail.com>
>>
>> BTW, here is a question:
>>    Why RAID6 doesn't allow the read-modify-write? I don't think it is
>>    not possible, so what prevents doing that? performance? complexity?
>>    or it's not possible? Why? :)
>
>
> The primary reason in my mind is that when Peter Anvin wrote this code he
> didn't implement read-modify-write and I have never seen a need to consider
> changing that.
>
> You would need a largish array - at least 7 devices - before RWM could
> possibly be a win, but some people do have arrays larger than that.
>
> The computation to "subtract" from the Q-syndrome might be a bit complex - I
> don't know.
>

The "subtract from Q" isn't difficult in theory, but it involves more 
cpu time than the "subtract from P".  It should be an overall win in the 
same was as for RAID5.  However, the code would be more complex if you 
allow for RMW on more than one block.

With raid5, if you have a set of data blocks D0, D1, ..., Dn and a 
parity block P, and you want to change Di_old to Di_new, you can do this:

Read Di_old and P_old
Calculate P_new = P_old xor Di_old xor Di_new
Write Di_new and P_new

You can easily extend this do changing several data blocks without 
reading in the whole old stripe.  I don't know if the Linux raid5 
implementation does that or not (I understand the theory here, but I am 
far from an expert on the implementation).  There is no doubt a balance 
between the speed gains of multiple-block RMW and the code complexity. 
As long as you are changing less than half the blocks in the stripe, the 
cpu time will be less than it would for whole stripe write.  For RMW 
writes that are more than half a stripe, the "best" choice depends on 
the balance between cpu time and disk bandwidth - a balance that is very 
different on today's servers compared to those when Linux raid5 was 
first written.



With raid6, the procedure is similar:

Read Di_old, P_old and Q_old.
Calculate P_new = P_old xor Di_old xor Di_new
Calculate Q_new = Q_old xor (2^i . Di_old) xor (2^i . Di_new)
                 = Q_old xor (2^i . (Di_old xor Di_new))
Write Di_new, P_new and Q_new

The difference is simply that (Di_old xor Di_new) needs to be multiplied 
(over the GF field - not normal multiplication) by 2^i.  You would do 
this by repeatedly applying the multiply-by-two function that already 
exists in the raid6 implementation.

I don't know whether or not it is worth using the common subexpression 
(Di_old xor Di_new), which turns up twice.



Multi-block raid6 RMW is similar, but you have to keep track of how many 
times you should multiply by 2.  For a general case, the code would 
probably be too messy - it's easier to simple handle the whole stripe. 
But the case of consecutive blocks is easier, and likely to be far more 
common in practice.  If you want to change blocks Di through Dj, you can do:

Read Di_old, D(i+1)_old, ..., Dj_old, P_old and Q_old.
Calculate P_new = P_old xor Di_old xor Di_new
                         xor D(i+1)_old xor D(i+1)_new
                         ...
                         xor Dj_old xor Dj_new


Calculate Q_new = Q_old xor (2^i . (Di_old xor Di_new))
                         xor (2^(i+1) . (D(i+1)_old xor D(i+1)_new))
                         ...
                         xor (2^j . (Dj_old xor Dj_new))
                 = Q_old xor (2^i .
                            (Di_old xor Di_new)
                            xor (2^1) . (D(i+1)_old xor D(i+1)_new))
                            xor (2^2) . (D(i+2)_old xor D(i+2)_new))
                            ...
                            xor (2^(j-i) . (Dj_old xor Dj_new))
                          )

Write Di_new, D(i+1)_new, ..., Dj_new, P_new and Q_new


The algorithm above looks a little messy (ASCII emails are not the best 
medium for mathematics), but it's not hard to see the pattern, and the 
loops needed.  It should also be possible to merge such routines with 
the main raid6 parity calculation functions.


mvh.,

David



> Peter: maybe you have a reason that I haven't mentioned?
>
> Thanks,
> NeilBrown
>

