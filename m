From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: array size
Date: Tue, 13 Dec 2005 11:15:33 -0500
Message-ID: <1134490533.10254.214.camel@localhost.localdomain>
References: <439EF06E.7050306@uiuc.edu>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <439EF06E.7050306@uiuc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Sharif Islam <mislam@uiuc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

4 disks, 0 spare, so 3x capacity

586075008 = 3 x 195358336

ming


On Tue, 2005-12-13 at 10:01 -0600, Sharif Islam wrote:
> Shouldn't the size of the array be around 760GB? It says spare device 0.
> 
> /dev/md0:
>         Version : 00.90.01
>   Creation Time : Mon Dec 12 15:56:58 2005
>      Raid Level : raid5
>      Array Size : 586075008 (558.92 GiB 600.14 GB)
>     Device Size : 195358336 (186.31 GiB 200.05 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Dec 13 09:59:54 2005
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

