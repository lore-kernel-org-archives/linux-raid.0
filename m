From: Doug Ledford <dledford@redhat.com>
Subject: Re: musical chairs
Date: Wed, 22 Sep 2004 17:17:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095887821.4196.1530.camel@compaq.xsintricity.com>
References: <001501c4a0d6$7818e740$7000a8c0@gordo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001501c4a0d6$7818e740$7000a8c0@gordo>
To: dr_snafu <dr_snafu@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2004-09-22 at 15:00, dr_snafu wrote:
> hello, 
> 
> i have a disk with data on it /dev/hdc, 
>     and a brand new empty disk /dev/hdb. 

Partitions not in use?

> want to set up raid 1 without moving data off hdc. 
>     it very large and i have no where to put it
> 
> will this work?: (notice # of devices)
> 
> mdadm --create --verbose /dev/md0 --level=1 
>         --raid-devices=1  /dev/hdb

Again, no partitions?  You can do that, don't get me wrong, but things
like raidautodetect work a bit more smoothly if you actually have a
partition table.

> will this create an unmirrored raid 1 setup? 
>     can i start and mount md0?
>     then copy the data from hdb to md0?
> 
> then?:
> 
> mdadm /dev/md0 --add /dev/hdc
> 
> 
> seems too good to be true, 
>     maybe you know another way?

Use e2fsresize or whatever it's called to shrink the size of the e2fs on
/dev/hdc by 64k, then mdadm -C /dev/md0 -l raid1 -n 2 /dev/hdc failed,
then mdadm /dev/md0 -a /dev/hdb and all the data will then be synced
from hdc to hdb and when it's done the raid array will be up, running,
and fully operational.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


