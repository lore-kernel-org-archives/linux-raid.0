From: Tejun Heo <tj@kernel.org>
Subject: Re: Velociraptor biting the dust (9th disk, continued to use it,
   and..)
Date: Mon, 24 Nov 2008 14:29:45 +0900
Message-ID: <492A3BC9.5080006@kernel.org>
References: <alpine.DEB.1.10.0811221638360.707@p34.internal.lan> <4928B40A.6020508@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4928B40A.6020508@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

Robert Hancock wrote:
> Justin Piszcz wrote:
>> I have several questions, to make things more clear I have segmented this
>> e-mail a bit-- any help with this issue would be greatly appreciated,
>> thank you.
>> ================================================================================
>>
>> So I continued to use the disk and it started failing again:
>> A Fail event had been detected on md device /dev/md2.
>> It could be related to component device /dev/sda3.
>> This is as it happened according to the kernel/dmesg:
> 
> (snip)
> 
>> BTW: I have already submitted an RMA for this disk (9th RMA!) I just
>> cannot get
>> over how many of these are failing.
> 
> That many bad drives in a row seems unlikely. I would tend to suspect
> some kind of other cause such as power issues, etc. though maybe it's
> some kind of design flaw..

Also, in many cases, simple resync is often enough to remove media
related errors as it makes the drive to rewrite and allows it to remap
if necessary but I admit I tend to have quite low standard regarding
hard drive quality.

Thanks.

-- 
tejun
