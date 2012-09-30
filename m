From: Chris Murphy <lists@colorremedies.com>
Subject: Re: MD RAID Bug 7/15/12
Date: Sat, 29 Sep 2012 20:47:51 -0600
Message-ID: <A65170A9-BE4D-4B22-B1CE-2FFE10928DDD@colorremedies.com>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 29, 2012, at 6:12 PM, Mark Munoz wrote:

> 
> Configuration:
> md0 is a RAID 6 volume with 24 devices and 1 spare.  It is working fine and was unaffected.
> md1 is a RAID 6 volume with 19 devices and 1 spare.  It was affected.  All the drives show as unknown raid level and 0 devices.  With the exception of device 5.  It has all the information.
> 
>         Layout : left-symmetric
>     Chunk Size : 4K

Off topic response: I'm kindof new at all of this. But 24 and 19 devices? Is this really ideal? Why not cap RAID6 to a max of 12 disks, and either use LVM or md raid linear to aggregate?

Chris Murphy