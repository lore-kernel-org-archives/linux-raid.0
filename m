From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Is it safe to shutdown while mdadm --grow is in progress.
Date: Sun, 12 Oct 2014 11:00:54 -0500
Message-ID: <543AA5B6.6010200@gmail.com>
References: <543A15A6.5010508@gmail.com> <20141012193555.69907c13@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141012193555.69907c13@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks. I appreciate you taking the time to respond. I would like to 
forward this to those that maintain faq/wiki so that some one searches 
gets the info and does not have to bother you. Is that OK?

I normally would go for backup before rebuild, but 15TB disk space is 
too much to come up with, without serious $$ and need. Besides, these 
are movies/recordings for htpc and the data is available on 
dvds/internet. So there is inherent lack of importance. In other words, 
I recommend backup as most do, but it looks like every one has some 
justification not to do, and want some one else to assure them that it 
is ok :-)

Thanks and Regards
Ramesh

On 10/12/2014 03:35 AM, NeilBrown wrote:
> On Sun, 12 Oct 2014 00:46:14 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:
>
>> I googled this topic and got differing answers. Some old ones report
>> horror stories and others suggest rebuild continues after reboot
>> normally. My array is rebuilding and it will take about 6 days to
>> complete. I am expecting bad weather in a couple of days and would like
>> to proactively shutdown the machine and reboot. Is this safe?
>>
>> If the information is already available in a clear manner, please let me
>> know.
>>
>> uname: Linux xxx 3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:28:38
>> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>> mdadm - v3.2.5 - 18th May 2012
>>
>> Thanks for your help
>>
> It is certainly designed to be safe and my experience is that it is.
> However it is difficult to test all corner cases so it is not impossible that
> someone what quite work right.
> If something does go wrong:
>   1/ don't panic
>   2/ don't try to --create the array to fix it
>   3/ report all details to this list and I'm 99.9% sure I can get your array
>      running again with all your data safe.
> But I suspect it won't come to that.
>
> NeilBrown

