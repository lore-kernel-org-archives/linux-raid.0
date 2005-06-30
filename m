From: Eric Pretorious <eric@pretorious.net>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Wed, 29 Jun 2005 17:38:30 -0700
Message-ID: <200506291738.30516.eric@pretorious.net>
References: <200506291538.03233.eric@pretorious.net>
Reply-To: eric@pretorious.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506291538.03233.eric@pretorious.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mike V <mike@asacomputers.com>, tech@asacomputers.com, Dinesh <dinesh@asacomputers.com>
List-Id: linux-raid.ids

On Wednesday 29 June 2005 03:38 pm, Eric Pretorious wrote:
>I'm trying to install CentOS 3.3 (a.k.a. RedHat Enterprise Linux 3) on a 
>Supermicro 5013C-M8 w/ on-board Adaptec AIC-7902 Ultra320 controller 
>(connected to two Seagate ST373207LC 73GB hdd's in RAID1 connfiguration) but 
>am getting random crashes. (The screen is FILLED with I/O errors and raid1 
>messages.)

After rebooting, I saw this message scroll by duing shutdown:

  md4: no spare disk to reconstruct array!  continuing in degraded mode

...so I restarted the system. After the system restarts, the array has the following status...

%> cat /etc/raidtab
  ...
  raiddev	/dev/md4
  raid-level				1
  nr-raid-disks				2
  chuck-size				64k
  perrsistent-superblock	1
  nr-spare-disks			0
	device				/dev/sda7
	raid-disk				0
	device				/dev/sdb7
	raid-disk				1
  ...

%> cat /proc/mdstat
  Personalities: [raid1]
  read_ahead 1024 sectors
  Event: 5
  ...
  md4 : active raid1 sdb7[1]
        50660864 blocks [2/1] [_U]

So it would appear that sda7 has failed. Is that correct?

-- 
Eric P.,
Truckee, CA
