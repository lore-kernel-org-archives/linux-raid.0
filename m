From: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Subject: Re: LVM on top of software raid5
Date: Sat, 4 Dec 2004 19:17:56 -0800
Message-ID: <20041205031756.GA3784@hamachi.dyndns.org>
References: <20041204215741.GA7828@hamachi.dyndns.org> <200412050309.iB539WJ5015009@ms-smtp-04.texas.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200412050309.iB539WJ5015009@ms-smtp-04.texas.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Unruh <jeff@jdubya.org>
Cc: 'Steven Joerger' <steven.joerger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 04 Dec 2004 21:10:01 -0600, Jeff Unruh wrote:
> I should have mentioned I boot off a Raid-1 array with Grub and manually
> update the 3rd disk's /boot ...
> 
> /dev/md0 (Raid 1) is 32 MB for /boot
> /dev/md1 (Raid 5) is 4 GB for /
> /dev/md2 (Raid 5 with LVM2 = /dev/vg0) is 366 GB for /home /usr /opt /var
> and /tmp
> 
> I am sure that set-up is debatable, but it has worked well thus far. 

You can make /dev/md0 a three-disk raid1 (instead of a two-disk).
Then you can dispense with the step of manually updating when you
change /boot.  Presumably writes to /boot are so rare that you don't
mind the penalty of triple-writing everything -- I don't.

-Steve

