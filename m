From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Recovering from default FC6 install
Date: Sat, 18 Nov 2006 07:24:38 -0500
Message-ID: <455EFB86.1040604@tmr.com>
References: <4556B86D.3030802@tmr.com>	<1163345905.4138.501.camel@fc6.xsintricity.com> <17755.42885.994680.290558@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17755.42885.994680.290558@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday November 12, dledford@redhat.com wrote:
>   
>> So, assuming that they are persistent, just recreate the arrays in place
>> as version 1.0 superblocks with internal bitmap.  I did that exact thing
>> on my FC6 machine I was testing with (raid1, not raid5, but no biggie
>> there) and it worked fine.  The detailed list of instructions:
>>
>>     
>
> You can add a bitmap to an array while it is active.
>   mdadm --grow --bitmap=internal /dev/mdX
>   

Thank you!!! Works like a charm!
> (Providing the kernel is new enough - I'm not sure when that went in,
> but it was a while ago).
The latest FC6 kernel is 2.6.18 something, should be okay.


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

