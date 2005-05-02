From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Mon, 02 May 2005 10:58:28 -0400
Message-ID: <42764014.5060909@steeleye.com>
References: <427583FA.7030704@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <427583FA.7030704@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tyler wrote:

> PS - I've tryed the latest 2.6.12-rc3-mm2 kernel, with mdadm v2.0-devel, 
> using the --metadata 1.0 option on the create line, and still get:

> # mdadm -C -e 1.0 -l 6 -n 31 /dev/md0 /dev/hdb /dev/hdc /dev/hdd 
> /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh 
> /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp 
> /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx 
> /dev/sdy /dev/sdz /dev/sdaa /dev/sdab
> mdadm: invalid number of raid devices: 31

As far as I can tell, mdadm just shouldn't give this error when you're 
using a version 1 superblock. If you disable that check in mdadm.c, I 
think everything will work. Version 1 superblocks allow something like 
2000 disks in an array.

--
Paul
