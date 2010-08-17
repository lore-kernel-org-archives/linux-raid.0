From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: too-old timestamp on backup-metadata
Date: Wed, 18 Aug 2010 09:09:21 +1000
Message-ID: <20100818090921.71bbabda@notabene>
References: <4C6AEA41.8030802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6AEA41.8030802@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Heaton <acroporas@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 Aug 2010 16:00:01 -0400
William Heaton <acroporas@gmail.com> wrote:

> *I am not on the mailing list.  Please include acroporas@gmail.com in 
> any replies.*
> 
> I had a 4-disk RAID5.  I added a 5th disk and at the same time converted 
> it to RAID6.
> 
> Things started out looking good, but after about a day, the reshape 
> appeared to have stalled.  After waiting more than 24 hours without 
> seeing any progress I rebooted the computer.  Immediately before the 
> rebooting the array was running and all data was accessible.  But after 
> reboot, the array would not start.  Can anyone help me get the array 
> restarted?  Thanks
> 
> ~$ uname -a
> Linux pholidochromis 2.6.32-24-generic #39-Ubuntu SMP Wed Jul 28 
> 05:14:15 UTC 2010 x86_64 GNU/Linux
> 
> ~$ mdadm --version
> mdadm - v3.1.2 - 10th March 2010
> 
> 
> ~$ sudo mdadm --assemble /dev/md0 /dev/sd[bcdel]1  -vv -f --backup-file 
> /media/Backup/rb
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdl1 is identified as a member of /dev/md0, slot 3.
> mdadm:/dev/md0 has an active reshape - checking if critical section 
> needs to be restored
> mdadm: too-old timestamp on backup-metadata on /media/Backup/rb
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
> 

cd /tmp
git clone git://neil.brown.name/mdadm
make
sudo ./mdadm --assemble /dev/md0 /dev/sd[bcdel]1  -vv -f --backup-file  /media/Backup/rb

If that still doesn't work.

sudo sh
export MDADM_GROW_ALLOW_OLD=1
./mdadm --assemble /dev/md0 /dev/sd[bcdel]1  -vv -f --backup-file  /media/Backup/rb

NeilBrown
