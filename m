From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: Customize the error emails of  `mdadm --monitor`
Date: Wed, 06 Jun 2007 14:23:31 +0200
Message-ID: <4666A743.3050900@rabbit.us>
References: <46619542.6010507@rabbit.us> <46669B20.6030706@rabbit.us> <20070606121121.GA23486@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070606121121.GA23486@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Iustin Pop wrote:
> On Wed, Jun 06, 2007 at 01:31:44PM +0200, Peter Rabbitson wrote:
>> Peter Rabbitson wrote:
>>> Hi,
>>>
>>> Is there a way to list the _number_ in addition to the name of a 
>>> problematic component? The kernel trend to move all block devices into 
>>> the sdX namespace combined with the dynamic name allocation renders 
>>> messages like "/dev/sdc1 has problems" meaningless. It would make remote 
>>> server support so much easier, by allowing the administrator to label 
>>> drive trays Component0 Component1 Component2... etc, and be sure that 
>>> the local tech support person will not pull out the wrong drive from the 
>>> system.
>>>
>> Any takers? Or is it a RTFM question (in which case I certainly 
>> overlooked the relevant doc)?
> 
> If you use udev, have you looked in /dev/disk? I think it solves the
> problem you need by allowing one to see either the disks by id or by
> path. Making the reverse map is then trivial (for a reasonable number of
> disks).
> 

This would not work as arrays are assembled by the kernel at boot time, 
at which point there is no udev or anything else for that matter other 
than /dev/sdX. And I am pretty sure my OS (debian) does not support udev 
in initrd as of yet.

Pete
