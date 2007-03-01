From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Growing a raid 6 array
Date: Thu, 1 Mar 2007 17:28:37 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703011728270.7560@p34.internal.lan>
References: <45E72549.2080108@unix-scripts.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45E72549.2080108@unix-scripts.info>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CARON <lcaron@unix-scripts.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can only grow a RAID5 array in Linux as of 2.6.20 AFAIK.

Justin.

On Thu, 1 Mar 2007, Laurent CARON wrote:

> Hi,
>
> As our storage needs are growing i'm in the process of growing a 6TB
> array to 9TB by changing the disks one by one (500GB to 750GB).
>
> I'll have to partition the new drives with bigger partitions and then
> fail the array, remove a drive, add a new 750GB disk.... repeat it as
> long as 500GB disks are remaining in the system.
>
> The question now is to know if i'm right, or ... simply wrong in
> thinking that this operation is then just as simple as:
>
> server:~# mdadm -G /dev/mdX -n number_of_disks(same as original array)
>
> once done, i'll have to grow the filesystem (ext3) by issuing
>
> server:~# resize2fs -p /dev/mdX
>
>
>
> Does the fact that the ext3 partition is nearly full involves a bigger
> risk of screwing the data ?
>
> Would it be better/worse to have a bitmap (internal one) on the mdX
> device while growing it ?
>
> Thanks
>
> Laurent
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
