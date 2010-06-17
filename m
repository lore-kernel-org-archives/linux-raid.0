From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 1 array degrades on reboot
Date: Fri, 18 Jun 2010 07:34:40 +1000
Message-ID: <20100618073440.373d8aa6@notabene.brown>
References: <4C19F5AF.5060300@team17.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C19F5AF.5060300@team17.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Watson <David.Watson@team17.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Jun 2010 11:15:11 +0100
David Watson <David.Watson@team17.com> wrote:

> Hello,
> 
> Recently I upgraded to 2Tb disks on one of my servers, I built a new
> degraded raid1 array:
> mdadm --create /dev/md7 -level 1 --raid-devices=2 missing /dev/sdd1
> 
> added its entry to /etc/mdadm/mdadm.conf then I rebooted to add the
> second disk and added it to the array:
> mdadm --manage /dev/md7  --add /dev/sdb1
> 
> I updated /etc/mdadm/mdadm.conf, although I noticed no difference in the
> output of:
> mdadm --detail --scan
> 
> 
> I use a monolithic kernel so there is no ramdisk to regenerate. This is
> my first 1.00 array, and the existing 0.9 arrays have never shown this
> issue. I have attempted the same process on a test server with no
> issues, and I can't really think of what to look at next.
> 
> apologies for the long post.
> 

Long posts are good....
However I cannot see in your long post what the actual problem is.
You have given no evidence that anything degrades on boot.
No kernel logs, no "/proc/mdstat immediately after boot"...

More info please.

NeilBrown
