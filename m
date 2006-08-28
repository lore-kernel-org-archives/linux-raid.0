From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 grow problem
Date: Mon, 28 Aug 2006 13:49:59 +1000
Message-ID: <17650.26600.47421.484642@cse.unsw.edu.au>
References: <7de068fd0608161815yc34ec6bl886fa637691ee5f8@mail.gmail.com>
	<7de068fd0608170223g2009962chc222233c70ee9317@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from  =?ISO-8859-1?Q?=20=1B$(AJfPG=1B(B?= on Thursday August 17
Sender: linux-raid-owner@vger.kernel.org
To: =?GB2312?B?yubQxw==?= <xshu2006@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 17, xshu2006@gmail.com wrote:
> dear sir:
>           i try to make a reshape command with mdadm (version
> 2.5.2).in linux shell ,i make
> $:mdadm -G /dev/md5 /dev/sdd2
> /dev/md5 is a raid5 device with 4 disks,/dev/sdd2 is a partition
> it give the prompt :mdadm :can only add devices to linear arrays,but i
> have read the resourse code of mdadm(V2.5.2),it do really support
> adding several disks into a array (espacially raid5) to make the array
> more large capability.

To restape a raid5 you need to give the new number of drives.
e.g.
  mdadm --grow /dev/md5 --raid-disk=5

You should hot-add sdd2 as a spare (--add /dev/sdd2_) before hand so
that the array isn't degraded when the reshape completes.

NeilBrown


> 
> i want to know  if i want to add(not hotadd) a disk(or a partition) to
> this array ,how can i make an reshape command correctly?
> i have read the help of mdadm ,but i still can't find the correct
> command format!
>     please  do me a favor!
>      thank you !
>                                                                         dragon
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
