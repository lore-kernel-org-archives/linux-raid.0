From: Zhilong Liu <zlliu@suse.com>
Subject: Re: Zombie dm device?
Date: Thu, 20 Apr 2017 10:55:45 +0800
Message-ID: <1e73e302-bdaa-b683-c6f2-3ba84fcaf80a@suse.com>
References: <3cf28b7e-9716-3595-018a-fecb32b61751@ubuntu.com>
 <ff1512f1-f499-43f9-daef-85cdaf1cb2ef@suse.com>
 <5b349798-c9de-04ef-d1dd-bc7774001903@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b349798-c9de-04ef-d1dd-bc7774001903@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Susi <psusi@ubuntu.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/18/2017 09:00 PM, Phil Susi wrote:
> On 4/17/2017 10:36 PM, Zhilong Liu wrote:
>> can you find the /sys/block/md99/md/array_state? issue the
>> # echo clear > /sys/block/md99/md/array_state  to stop array.
>> The test suit is in improving progress, a few test cases cannot
>> work well currently. you can talk about your requirement, and
>> I would record it. more details, more appreciate. :-)
> It already said it was clear.  Attempting to clear it again apparently
> rebooted the virtual machine and for some reason, syslog and kern.log
> are empty and the previous one is last dated 8 days ago.
>
> Odd that it just rebooted too since I'm pretty sure a panic should have
> just halted the system with the panic message written to the vnc console.

however, we cannot put up with panic, would you mind to retest and lock 
on which test
case triggered panic and reproduced, I would test it on my site and find 
why it happens.

Thanks,
-Zhilong

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

