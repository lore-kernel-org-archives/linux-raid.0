From: Michal Soltys <nozo@ziu.info>
Subject: Re: md device naming question
Date: Tue, 25 Sep 2007 06:49:25 +0200
Message-ID: <46F89355.9040201@ziu.info>
References: <20070919081022.GA26155@stro.at> <87lkawzge0.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lkawzge0.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nix wrote:
> On 19 Sep 2007, maximilian attems said:
> 
>>
>> i presume it may also be /sys/block/mdNN ?
> 
> That's it, e.g. /sys/block/md0. Notable subdirectories include holders/
> (block devices within the array, more than one if e.g. LVM is in use),
> 

Also, if you mount the raid as a partitionable one, /sys/block/md_dNN ;

mdadm has pretty decent handling of all the names (check out auto options, 
both usable in mdadm.conf and from command line). Also from my experience, 
if you try to use udev on partitionable arrays, partition related uevents 
will be delayed until next mdadm invocation, or some partition related 
command (like fdisk).


