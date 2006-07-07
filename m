From: Neil Brown <neilb@suse.de>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Sat, 8 Jul 2006 08:31:41 +1000
Message-ID: <17582.57549.204471.855655@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan>
	<Pine.LNX.4.64.0607070845280.2648@p34.internal.lan>
	<Pine.LNX.4.64.0607070849140.3010@p34.internal.lan>
	<Pine.LNX.4.64.0607071037190.5153@p34.internal.lan>
	<17582.55703.209583.446356@cse.unsw.edu.au>
	<Pine.LNX.4.64.0607071814510.8499@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Friday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 7, jpiszcz@lucidpixels.com wrote:
> 
> Hey!  You're awake :)

Yes, and thinking about breakfast (it's 8:30am here).

> 
> I am going to try it with just 64kb to prove to myself it works with that, 
> but then I will re-create the raid5 again like I had it before and attempt 
> it again, I did not see that documented anywhere!! Also, how do you use 
> the --backup-file option? Nobody seems to know!

man mdadm
       --backup-file=
              This  is  needed  when  --grow is used to increase the number of
              raid-devices in a RAID5 if there  are no  spare  devices  avail-
              able.   See  the section below on RAID_DEVICE CHANGES.  The file
              should be stored on a separate device, not  on  the  raid  array
              being reshaped.


So e.g.
   mdadm --grow /dev/md3 --raid-disk=7 --backup-file=/root/md3-backup

mdadm will copy the first few stripes to /root/md3-backup and start
the reshape.  Once it gets past the critical section, mdadm will
remove the file.
If your system crashed during the critical section, then you wont be
able to assemble the array without providing the backup file:

e.g.
  mdadm --assemble /dev/md3 --backup-file=/root/md3-backup /dev/sd[a-g]

NeilBrown
