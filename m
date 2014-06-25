From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Wed, 25 Jun 2014 08:59:00 +0200
Message-ID: <53AA7334.1010402@gmail.com>
References: <53A99B76.3020603@gmail.com> <20140625110348.48ab2d7a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140625110348.48ab2d7a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,

On 06/25/2014 03:03 AM, NeilBrown wrote:
[...]

>>
>> After waiting a couple of min, stopping again md126 worked:
>>
>> [ 1835.755661] md: md126 stopped.
>>
>> Is this expected ?
> 
> No overly surprising.
> 
> This is probably caused by udev, or something udev runs, opening /dev/md126
> after it has been stopped.  This has the effect of creating an empty inactive
> array.
> e.g.
> 

Why opening /dev/md126 after it's been stopped didn't fail ?

Also why doing 'mdadm --stop /dev/md126' several times reports that the
array was stopped each time ?

>  mknod /dev/test b 9 57
>  < /dev/test
> 
> will make /sys/block/md57 appear.
> 
> It is a bit untidy, but shouldn't cause problems.
>

Another 'inconsistent' state I noticed is when a new array is created.
There's a time window when /sys//block/md127/md exists but the contained
disk (dev-sda1 dev-sdb1, for example) are not present in that directory.
This state (as the previous one) confuses my tool that is listening udev
events in order to register all block devices present in the system.

So I am wondering how I should deal with this 'transition' states and
how can detect them in a reliable way ?

Thanks.
