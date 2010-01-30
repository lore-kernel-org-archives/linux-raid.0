From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Sat, 30 Jan 2010 19:44:30 +0100
Message-ID: <4B647E0E.6050609@texsoft.it>
References: <4B5F6C73.30707@texsoft.it>	<20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129214852.00e565c4@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


>>> Is this some kind of bug?  
>>>       
>> No
>>     
> I'm not sure I agree.
>   

Hm funny ... I just read now from md's man:

"In  kernels  prior to about 2.6.15, a read error would cause the same 
effect as a write error.  In later kernels, a read-error will instead 
cause md to attempt a recovery by overwriting the bad block. .... "

So things have changed since 2.6.15 ... I was not so wrong to expect 
"the old behaviour" and to be disappointed.
But something important was missing during this change imho:
1) let the old behaviour be the default: add 
/sys/block/mdXX/max_correctale_read_errors, with default to 0.
2) let the new behaviour be the default, but update mdadm and 
/proc/mdstat to report read error events.

I think the situation is now quite clear.
Thanks

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


