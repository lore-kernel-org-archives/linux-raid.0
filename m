From: David Greaves <david@dgreaves.com>
Subject: Re: Help - this doesn't look good...
Date: Tue, 30 Nov 2004 09:03:23 +0000
Message-ID: <41AC375B.50906@dgreaves.com>
References: <41A5D897.3010600@dgreaves.com> <16811.55711.183234.578489@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16811.55711.183234.578489@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Thursday November 25, david@dgreaves.com wrote:
>  
>
>>Sigh,
>>
>>I'm having what might be xfs/nfsd conflicts and thought I'd reboot into 
>>an old 2.6.6 kernel which used to be stable.
>>
>>Of course it spotted the fd partitions and tried to start the array.
>>It failed (the old kernel didn't have a driver for the new controller so 
>>some devices were missing)
>>
>>However when I came back to 2.6.9 I get the rather conflicting status 
>>shown below.
>>    
>>
>
>You might need to explain to me what is "conflicting".  It looks to be
>like the array as 6 working devices and one spare, and that due to an
>unclean shutdown it is resyncing the 6 working devices.
>  
>
That's good - I wasn't aware of that mode of operation.
The only time I thought that a resync occurred was if a drive 'failed' 
and was then hot-added. Seeing a resync and no inactive drives looked 
inconsistent.

mdadm doesn't indicate which drive is resyncing?
Is there a particular drive at fault or is this more of a sync-check 
than a resync?

Maybe one for the docs:

The md raid driver will resync in two situations; a resync occurs when a 
drive is hot-added to a degraded array (usually at first assembly and 
any time after a drive failure). In this case the array will show the 
resyncing drive as inactive until the resync completes and it is 
integrated into the array; a resync can also occur after an unclean 
shutdown when (presumably) there is an inconsistency in the array 
devices. In this case all the elements are still active and the resync 
is just checking to ensure no corruption has occurred.

David


