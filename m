From: Avijit Pathania <foulplay@foulplay.org>
Subject: Re: RAID SYNC
Date: Fri, 11 Jul 2003 06:39:52 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F0E93F8.1030501@foulplay.org>
References: <017101c34779$37d581a0$c9e903ca@magnus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mikael Chambon <raid-ml@cronos.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looks like you do not have DMA enabled. `dmesg |grep -i dma` to see if 
system recognized it and `hdparm -d /dev/hda` to check if it is enabled.
Check if your IDE chipset is configured in the kernel. Or usr 
/etc/sysconfig/harddisks to enable it using hdparm.

It should take around 30mins for it to finish resync.

HTH
Avijit

Mikael Chambon wrote:

>Hi Again,
>
>My second question is about RAID sync.
>
>Just for my curiosity, I am testing RAID1 on two empty 110 gig partitions, 
>the system takes about 3h30 to resync, why is it taking so long ?
>
>Here is my idea: As the RAID layer has nothing to do with the FS layer,
>the raid driver (I use md) does not and can't see the difference between 
>a used block of data and an unused block of data. That's why it has to 
>resync everything. Am I right ?
> 
>Thanks guys,
>--
>Mikael Chambon
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>


