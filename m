From: David Brown <david.brown@hesbynett.no>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Sat, 14 May 2011 20:21:48 +0200
Message-ID: <iqmh7s$eb4$1@dough.gmane.org>
References: <4DCD4A83.8060202@pulseforce.com> <4DCD6119.3080705@turmel.org> <4DCD67EF.1070602@pulseforce.com> <4DCD6B27.70402@pulseforce.com> <20110513234055.4307c536@natsu> <4DCD72AF.1070809@pulseforce.com> <4DCD75FE.8010703@turmel.org> <4DCD7E78.6050000@pulseforce.com> <4DCD84E1.3040704@turmel.org> <20110514013221.552dc8ef@natsu> <iqlkfg$1s9$1@dough.gmane.org> <20110514162427.143668d6@natsu> <iqlu6n$duh$1@dough.gmane.org> <BANLkTin0qRZXYzWBTXUJqdHmaQR_p1VfUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTin0qRZXYzWBTXUJqdHmaQR_p1VfUA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/05/11 15:27, Drew wrote:
>> I'm sure that LV's could be defragmented - there is already code to move
>> them around on the disks (such as to move them out of a PV before deleting
>> the PV).  I don't know why it hasn't been implemented - maybe there are too
>> few people working on LVM, or that it is a low priority, or that LV
>> fragmentation makes very little measurable difference in practice.
>
> I've always figured it was because fragmentation in the LV's caused
> little performance degradation. If we were talking about LV's composed
> of hundreds of fragments I would expect to see degradation but I've
> never come across a scenario where LV's have been that bad.
>

I too think the fragmentation is probably a small effect - but it is 
maybe a measurable effect nonetheless.  I've never seen any benchmarks 
on it.  However, I know that some filesystems (such as xfs in 
particular, and ext4 to a lesser extent) go out of their way to reduce 
the risk of fragmentation in files - if it is worth their effort, then 
perhaps it is also worth it for LVM.

> Someone refered to DOS in an earlier post and I think that's a good
> example of relevance. I maintain a bunch of Windows based machines at
> work and I did some performance benchmarking between a traditional
> defrag utility and some of the "professional" versions. Bells and
> whistles aside, what set most of the Pro versions apart from the
> standard defrag utilities was the concept of "good enough" defrag,
> which basically puts files into several larger fragments as opposed to
> a complete defrag. I ran tests on filesystem performance before and
> after defraging drives with both options and the change in performance
> between a full defrag and a "good enough" defrag was minimal.
>

You will probably also find that the real-world difference between no 
defrag and "good enough" defrag is also minimal.

There are some heavily used files and directories that get so badly 
fragmented in windows systems that they can benefit from a defrag - for 
example the registry files, the windows directory, and some of the NTFS 
structures.  Of course, these are the parts that normal defrag utilities 
can't help - they can't be defragged while the system is running.  But 
for most other parts of the system, defrag makes very little real 
difference, especially as it is so temporary.

In the old days, before DOS and Windows had any sort of file or disk 
cache, defraging had a bigger effect.  But now you are far better off 
spending money on some extra ram for more cache space than on 
"professional" defrag programs.



