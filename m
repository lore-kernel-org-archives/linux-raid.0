From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Sat, 28 Jun 2008 06:47:29 +1000
Message-ID: <18533.20961.694041.556763@notabene.brown>
References: <48650567.3000501@w1nr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike McCarthy on Friday June 27
Sender: linux-raid-owner@vger.kernel.org
To: Mike McCarthy <mike@w1nr.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 27, mike@w1nr.net wrote:
> Hello Neil and Linus,

I've dropped Linus from cc as he won't be interested, and added
linux-raid.

>     I am contacting both of you because you have submitted md raid code 
> to the 2.6.25 kernels.  I have found an apparent deadlock condition 
> using software RAID1 with SUSE 11.0 and Fedora 9, both which use the 
> 2.6.25 kernels.  Configuration is as follows:
> 
>     Dell Precision 450 with single Xeon 2.4 GHz processor 
> (hyperthreaded, looks like a dual core)
>     2 Seagate 120GB IDE drives
>        sda1,sdb1 - 1GB swap
>        sda2,sdb2 - 100MB, RAID1, md0,  /boot
>        sda3,sdb3 - balance of disk, RAID1, md1 3 LVM filesystems
> 
>    System locks up after running a short time.  Had it hang once during 
> installation.  Tried both Reiserfs and EXT3.

We need more details about the lockup.  Does the whole system lock up,
or just the array.
Can  you get
   alt-sysrq-T
output?  That might be useful.
  

> 
>    Are either of you aware of this issue?  If not, I can file a bugzilla.

No I'm not aware of such an issue.
I prefer to avoid bugzilla, lets just discuss it here.

NeilBrown
