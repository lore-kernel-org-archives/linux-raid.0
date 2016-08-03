From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: WARNING: CPU: 4 PID: 10512 at drivers/md/raid5-cache.c:728
 r5l_do_reclaim+0x415/0x430 [raid456]
Date: Wed, 3 Aug 2016 10:46:48 +0800
Message-ID: <57A15B18.80305@suse.com>
References: <2099656990.9407283.1469619529240.JavaMail.zimbra@redhat.com>
 <579F0E52.8090704@suse.com> <7d0acb42-1209-0722-7740-0fa03d44106b@redhat.com>
 <57A05B70.9060500@suse.com> <bd2bb3a9-f970-7726-00b7-1956d2223ef1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bd2bb3a9-f970-7726-00b7-1956d2223ef1@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: yizhan <yizhan@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/02/2016 09:31 PM, yizhan wrote:
>
>> I tried with latest Linus's tree 
>> (731c7d3a205ba89b475b2aa71b5f13dd6ae3de56), but still can't find the 
>> warning.
>>
>> linux241:~ # uname -r
>> 4.7.0-11-default+
>> linux241:~ # mdadm --version
>> mdadm - v3.4-41-gf96b130 - 30th March 2016
>>
>> The biggest difference is that I am using VM machine while you were 
>> testing with real hardware, though I am not
>> sure it was caused by hardware or not. Do you always see the 
>> "couldn't update array info" info during test? If so,
>> pls try to make it disappear.
>>
>> Thanks,
>> Guoqing
> May be it's env related, I have tried on another PC which with the 
> same kernel/mdadm version and cannot reproduce it.

I guess you can check the difference of hardware about why it can't be 
happen with another PC.

Regards,
Guoqing
