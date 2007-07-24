From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFH] Partion table recovery
Date: Tue, 24 Jul 2007 05:45:12 +0200
Message-ID: <46A575C8.80208@gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <46A50AD6.6050806@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46A50AD6.6050806@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 07/23/2007 10:08 PM, Bill Davidsen wrote:

> Al Boldi wrote:

>> As always, a good friend of mine managed to scratch my partion table 
>> by cat'ing /dev/full into /dev/sda.  I was able to push him out of the 
>> way, but at least the first 100MB are gone.  I can probably live 
>> without the first partion, but there are many partitions after that, 
>> which I hope should easily be recoverable.
>>
>> I tried parted, but it's not working out for me.  Does anybody know of 
>> a simple partition recovery tool, that would just scan the disk for 
>> lost partions?
>>   
> You have gotten a bunch of thoughts on this, I will just say that plain 
> old "fdisk -l" saved somewhere safe is probably all you need, in human 
> readable format. Doesn't do you any good now, but all the complicated 
> schemes discussed don't thrill me, I want to be able to see this, and 
> recovery by partition table manual rebuild is so rare I would rather do 
> it by hand than trust some software I rarely use.

ACK. Or NNAK (Non-NAK) at least...

Rene.

