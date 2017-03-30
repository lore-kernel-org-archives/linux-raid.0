From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID6 rebuild oddity
Date: Thu, 30 Mar 2017 11:09:08 +0800
Message-ID: <eec1041f-6844-f8c4-bc68-0e2a1304b4ec@fnarfbargle.com>
References: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com>
 <87zig467z3.fsf@notabene.neil.brown.name>
 <5584b8b1-b4f1-0d2e-cbf3-f14b4127d031@fnarfbargle.com>
 <87wpb7612w.fsf@notabene.neil.brown.name>
 <a8ad0de2-5cec-1e70-0fff-1df911a02932@fnarfbargle.com>
 <87r31f5y3m.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r31f5y3m.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Linux-RAID <linux-raid@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On 30/03/17 09:53, NeilBrown wrote:
> On Thu, Mar 30 2017, Brad Campbell wrote:
>
>>        [==============>......]  recovery = 72.0% (4222847296/5860391360)
>> finish=541.6min speed=50382K/sec
> ...
>>        [==============>......]  recovery = 73.3% (4297641980/5860391360)
>> finish=284.7min speed=91465K/sec
>>
>
>>
>> So that has significantly increased the rebuild speed, as you would expect.
>>
>
> Not quite twice as fast, but close!

It's actually more than twice as fast.
       [================>....]  recovery = 84.1% (4933147664/5860391360) 
finish=151.4min speed=102062K/sec

That sample was taken at an inopportune moment when things were just 
getting up to speed. We're progressing towards slower parts of the disk, 
and it's still twice as fast as it was.

> Everyone has been suffering with that poor speed for years and nobody
> noticed until you did.  Thanks for being thorough!  And thanks for
> confirming the patch.

I'm baffled it has been around this long and it hasn't come up previously.

Again, I really appreciate you taking a look at this.

Regards,
Brad
