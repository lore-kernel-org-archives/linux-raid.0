From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Tue, 8 Jul 2008 09:15:45 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan> <alpine.LFD.1.10.0807081232350.32659@bbs.intern>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807081232350.32659@bbs.intern>
Sender: linux-raid-owner@vger.kernel.org
To: Gerhard Wiesinger <lists@wiesinger.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 8 Jul 2008, Gerhard Wiesinger wrote:

> On Tue, 8 Jul 2008, Justin Piszcz wrote:
>
>> 
>> 
>> On Tue, 8 Jul 2008, Gerhard Wiesinger wrote:
>> 
>>> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>>> 
>>>> Hi Gerhard,
>> 
>> Please run:
>> 
>> smartctl -t short /dev/sdc
>> sleep 300
>> smartctl -t long /dev/sdc
>> 
>> Wait 2-3 hours or more and:
>> 
>> smartctl -a /dev/sdc
>
>
> I'm changing the disk one more time ...

Once you replace the disk please re-run the tests shown above and show us 
the output please.

How many SAMSUNG disks have you gone through, do they really fail that 
often?

Justin.
