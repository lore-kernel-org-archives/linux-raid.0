From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 02 Feb 2011 22:22:55 +0100
Message-ID: <iichvf$ebq$1@dough.gmane.org>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>	<20110202043605.593f0c5c@natsu>	<AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>	<20110202144726.GB18517@cthulhu.home.robinhill.me.uk>	<iic0k1$950$1@dough.gmane.org> <AANLkTinvurdEuDFcXycrf=5qoZwEjxSc2izf8e0dgQAq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinvurdEuDFcXycrf=5qoZwEjxSc2izf8e0dgQAq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/11 17:48, hansbkk@gmail.com wrote:
> On Wed, Feb 2, 2011 at 11:24 PM, David Brown<david@westcontrol.com>  wrote:
>> Of course, there is a cost - if you have 15 2TB drives, with one being a
>> warm spare shared amongst the raid1 pairs, you have only 6 x 2TB storage.
>
> Please correct me if I got the math (or anything else) wrong.
>
> If one didn't implement RAID5 (rather just using RAID0 or LVM) over
> the RAID1s, and were OK with the 6x2TB usable space out of 15 drives,
> then you'd have three spares (actually hot spares right?), allowing
> for *any four* drives to fail (but still as long as it wasn't a
> matched pair within the _much shorter_ rebuild time window.)
>

Your maths is okay - it's your understanding of failures that is wrong :-)

If you use raid0 over your raid1 pairs, and you lose both halves of a 
raid1 pair, you data is gone.  You can have a dozen hot spares if you 
want, it still doesn't matter.

The point of having multiple redundancy is to handle multiple failures 
at the same time, or while doing a rebuild.  Hot spares are there so 
that a rebuild can start automatically without someone feeding a new 
drive in the machine, thus minimising your risk window.  But they don't 
improve the redundancy themselves.

The /really/ good thing about a hot spare is that the administrator 
doesn't have to remove the faulty disk until the array is rebuilt, and 
safely redundant again.  That way there is no disaster when he removes 
the wrong disk...


> While a RAID6+spare, where any three can fail (and unlike the above
> any two can fail within the (admittedly longer) rebuild window, gives
> *double* the usable space - 12x2TB.

Again, you are incorrect about the number of drives that can fail. 
RAID6 + spare means any /two/ drives can fail.  You are correct about 
having a lot more usable space, but you have lower redundancy and a lot 
longer rebuild times.


