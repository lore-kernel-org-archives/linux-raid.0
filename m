From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID partitions, or RAID disks and partition array?
Date: Fri, 22 Aug 2014 19:28:40 +0200
Message-ID: <20140822172840.GA3843@lazy.lzy>
References: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Aug 22, 2014 at 09:52:11AM -0700, Adam Talbot wrote:
> I hope this is an easy one.  I have two drives I would like to mirror
> as my boot drive.
> 1) Should I mirror the drives, then partition the RAID device (md0)?
> 2) Should I partition the the drives then RAID the partitions?
> 
> What is the best practice, and why?

Hi Adam,

if I understand it correctly, being a boot drive,
you'll have to install a boot loader, so you'll
need some space between the beginning of your data
(or RAID in this case) and the boot loader.
This means, as far as I know, your *only* choice
is to partition.

Or I miss something...

bye,

pg

> 
> Thanks
> Adam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
