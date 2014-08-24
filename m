From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID partitions, or RAID disks and partition array?
Date: Sun, 24 Aug 2014 12:53:06 +0200
Message-ID: <53F9C412.3010909@hesbynett.no>
References: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/08/14 18:52, Adam Talbot wrote:
> I hope this is an easy one.  I have two drives I would like to mirror
> as my boot drive.
> 1) Should I mirror the drives, then partition the RAID device (md0)?
> 2) Should I partition the the drives then RAID the partitions?
>
> What is the best practice, and why?
>
> Thanks
> Adam


Mirroring drives is conceptually simpler, and can be faster if you are 
trying to make a system optimised for speed for particular loads. 
Mirroring partitions involves a few more steps, but gives more flexibility.

My usual setup for two drives on a workstation is to use partitions.  I 
have a small partition on each drive, with a raid1 mirror (with 0.9 
metadata), that is used for /boot.  Any bootloader will be happy with 
that.  Then there is a partition on each drive for swap space - the 
kernel will use both as a sort of raid0, so there is no need for raiding 
here (high availability servers would put swap on raid, but it is not 
really needed for "normal" PC's).  The rest of the drives are a single 
large partition, which I then put together with raid10,far2 - or 
possibly a btrfs filesystem with btrfs raid1.

But as has been said, there are no hard and fast rules.  mdadm gives you 
a level of flexibility well beyond anything you get with hardware raid, 
but the cost of that is that you have to make some decisions!  If you 
have a specific setup in mind, you can always ask here for opinions.

David


