From: Neil Brown <neilb@suse.de>
Subject: Re: EVMS causing problems with mdadm?
Date: Mon, 24 Apr 2006 07:48:00 +1000
Message-ID: <17483.62992.692017.319991@cse.unsw.edu.au>
References: <6d5bedd80604230833m3614f453we869b8bf7261d0e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ewan Grantham on Sunday April 23
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday April 23, ewan.grantham@gmail.com wrote:
> Did my latest updates for my Kubuntu (Ubuntu KDE variant) this
> morning, and noticed that EVMS has now "taken control" of my RAID
> array. Didn't think much about it until I tried to make a RAID-1 array
> with two disks I've just added to the system. Trying to do a create
> verbose tells me that device /dev/md1 (or 2 or 3 - I tried a couple
> just to see) doesn't exist. And in fact, there are no block devices
> listed beyond md0.

Sounds like udev is in use rather than a static /dev.

Add '--auto=md' to the mdadm command line, and it will create the
devices for you.  Or --auto=part if you want partitioned arrays.  See
man page for more details.

I suspect this might need to be come the default in another year or so....

NeilBrown

> 
> Trying to go into EVMS to create a new Volume brings up the screen for
> doing so, but doesn't actually let you create a new one.
> 
> Any suggestion of what I might be doing wrong, or is this a bug I
> should be reporting to the Ubuntu folks?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
