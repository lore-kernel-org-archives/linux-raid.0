From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: md raid acceleration and the async_tx api
Date: Thu, 13 Sep 2007 14:14:19 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0709131412240.10858@filesrv1.baby-dragons.com>
References: <200709071444.34911.yur@emcraft.com>
 <0C7297FA1D2D244A9C7F6959C0BF1E520268732A@azsmsx413.amr.corp.intel.com>
 <200709131338.17972.yur@emcraft.com> <e9c3a7c20709130952w7c6fed5fo76c78bef299bdb9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20709130952w7c6fed5fo76c78bef299bdb9e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Dan ,

On Thu, 13 Sep 2007, Dan Williams wrote:
> On 9/13/07, Yuri Tikhonov <yur@emcraft.com> wrote:
>>  Hi Dan,
>> On Friday 07 September 2007 20:02, you wrote:
>>> You need to fetch from the 'md-for-linus' tree.  But I have attached
>>> them as well.
>>>
>>> git fetch git://lost.foo-projects.org/~dwillia2/git/iop
>>> md-for-linus:md-for-linus
>>
>>  Thanks.
>>
>>  Unrelated question. Comparing the drivers/md/raid5.c file in the Linus's
>> 2.6.23-rc6 tree and in your md-for-linus one I'd found the following
>> difference in the expand-related part of the handle_stripe5() function:
>>
>> -               s.locked += handle_write_operations5(sh, 1, 1);
>> +               s.locked += handle_write_operations5(sh, 0, 1);
>>
>>  That is, in your case we are passing rcw=0, whereas in the Linus's case the
>> handle_write_operation5() is called with rcw=1. What code is correct ?
>>
> There was a recent bug discovered in my changes to the expansion code.
> The fix has now gone into Linus's tree through Andrew's tree.  I kept
> the fix out of my 'md-for-linus' tree to prevent it getting dropped
> from -mm due to automatic git-tree merge-detection.  I have now
> rebased my git tree so everything is in sync.
>
> However, after talking with Neil at LCE we came to the conclusion that
> it would be best if I just sent patches since git tree updates tend to
> not get enough review, and because the patch sets will be more
> manageable now that the big pieces of the acceleration infrastructure
> have been merged.
>
>>  Regards, Yuri
>
> Thanks,
> Dan
 	Does this discussion of patches include any changes to cure the 'BUG' 
instance I reported ?

 	ie: raid5:md3: kernel BUG , followed by , Silent halt .

 		Tia ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
