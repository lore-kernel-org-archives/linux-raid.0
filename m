From: Avijit Pathania <foulplay@foulplay.org>
Subject: Re: RAID recovery
Date: Fri, 11 Jul 2003 06:51:44 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F0E96C0.8080403@foulplay.org>
References: <017b01c34779$57e66e00$c9e903ca@magnus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mikael Chambon <raid-ml@cronos.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After you have replaced the drive, the raid will start in degraded mode 
using only one half of the mirror. It will not replace the failed drive 
automatically, even though that drive exists.

To answer your question make sure that you pass the correct path of the 
drive that you have just added as the argument to raidhotadd. From the 
looks of your configuration from your previous email, the drive will 
need to have the various slices created before it can be added to the 
existing raid setup.


Mikael Chambon wrote:

>Hi again,
>
>Here is my last question about RAID for now.
>
>I saw a lot of docs about RAID installation, but I was not able to find
>one which clearly explain what to do after a HD crash. Does someone has a
>good link for me ?
>
>For example, let's say I have two new IDE HD in a RAID1 array, raid-disk1
>and
>raid-disk2. If raid-disk1 crash, I have to (from linux-raid-How-to)
>
>Power down the system
>replace the failed disk
>powerup the system
>user raidhotadd to insert the new disk in the array as raid-disk1
>
>
>But what should I do to make sure that raid-disk1 will reconstruct from
>raid-disk2 ? If raid-disk2 reconstruct from raid-disk1, I will lose all
>my data right ?
>
>Thanks for all guys,
>
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


