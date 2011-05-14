From: David Brown <david.brown@hesbynett.no>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Sat, 14 May 2011 14:56:55 +0200
Message-ID: <iqlu6n$duh$1@dough.gmane.org>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com>	<20110513234055.4307c536@natsu>	<4DCD72AF.1070809@pulseforce.com>	<4DCD75FE.8010703@turmel.org>	<4DCD7E78.6050000@pulseforce.com>	<4DCD84E1.3040704@turmel.org>	<20110514013221.552dc8ef@natsu>	<iqlkfg$1s9$1@dough.gmane.org> <20110514162427.143668d6@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514162427.143668d6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/05/11 12:24, Roman Mamedov wrote:
> On Sat, 14 May 2011 12:10:56 +0200
> David Brown<david.brown@hesbynett.no>  wrote:
>
>> What is perhaps more relevant, is can filesystems see the fragmentation
>> of the LV's?  I don't know the answer.
>
> No, of course they can't.
>
>> Still, you don't usually have many segments in an LV - if you want the
>> LV to be fast, you can request it to be contiguous when creating it.
>> Then you only get a fragment for each time it is grown.  It's a price
>> often worth paying for the flexibility.
>
>  From what I see, the key selling point for LVM is the ability to 'easily'
> add/remove/resize LVs. And then if you buy that and start to actively use
> these features, you end up in a situation (badly fragmented LVs) from which
> there isn't a proper way out. No - backup and restore, or 'have enough
> contiguous free space to mirror your entire LV and then nuke the original' are
> not the answer. What's sad is that there isn't any fundamental technical
> reason LVs can't be defragmented. They can, just no one has bothered to write
> the corresponding code yet.
>

I'm sure that LV's could be defragmented - there is already code to move 
them around on the disks (such as to move them out of a PV before 
deleting the PV).  I don't know why it hasn't been implemented - maybe 
there are too few people working on LVM, or that it is a low priority, 
or that LV fragmentation makes very little measurable difference in 
practice.

Personally, I find LVM to be a hugely useful tool.  I like being able to 
make new logical volumes when I need them, and resize them as 
convenient.  For servers, I make heavy use of openvz lightweight virtual 
serving, and I make a new LV for each "machine".  So setting up a new 
"server" with its own "disk" is done in a couple of minutes.  And if the 
needs of the "server" outgrow its bounds, it's easy to extend it.

I've had plenty of other cases where LVM has saved me a lot of time and 
effort.  It's not that long ago since I temporarily needed a bit more 
space on a server, and didn't have the time or spare disk to build it 
out.  So I added a USB disk I had lying around, made a PV on it, and 
extended the server's LVs onto the disk.  Obviously this sort of thing 
gives a performance hit - but it was better to be slow than not working. 
  For me, LVM's flexibility is worth the minor performance cost.

