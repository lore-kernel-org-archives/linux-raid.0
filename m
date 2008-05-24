From: David Greaves <david@dgreaves.com>
Subject: RFI for 2.6.25.5 : Re: Regression- XFS won't mount on partitioned
 md array
Date: Sat, 24 May 2008 14:33:35 +0100
Message-ID: <4838192F.3050004@dgreaves.com>
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <482FED60.7060405@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Greg
Perusing:
  http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git
doesn't show the patch referenced below as in the queue for 2.6.25.5

David

David Greaves wrote:
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Eric Sandeen wrote:
>>>
>>>> I'll see if I have a little time today to track down the problem.
>>> Does this patch fix it for you?  Does for me though I can't yet explain
>>> why ;)
>>>
>>> http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html
>>>
>>> -Eric
> Yes, this fixes it for me - thanks :)
> 
>> So what's happening is that xfs is trying to read a page-sized IO from
>> the last sector of the log... which goes off the end of the device.
>> This looks like another regression introduced by
>> a9759f2de38a3443d5107bddde03b4f3f550060e, but fixed by Christoph's patch
>> in the URL above, which should be headed towards -stable.
> Damn, I guess I misread my bisect readings when things crashed then.
> Still, I said 'around' :)
> 
>> (aside: it seems that this breaks any external log setup where the log
>> consists of the entire device... but I'd have expected the xfsqa suite
>> to catch this...?)
>>
>> The patch avoids the problem by looking for some extra locking but it
>> seems to me that the root cause is that the buffer being read at this
>> point doesn't have it's b_offset, the offset in it's page, set.  Might
>> be another little buglet but harmless it seems.

