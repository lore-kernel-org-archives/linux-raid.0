From: Brandon Evans <maillists@hosttuls.com>
Subject: Re: Kernal Panic when booting redhat.  Raid devices mount fine underKnoppix
Date: Fri, 12 Dec 2003 09:46:19 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD9FEEB.7040006@hosttuls.com>
References: <3FD7A643.7060602@hosttuls.com> <3FD822D4.2030501@ratnet.stw.uni-erlangen.de> <3FD8ECA9.9080209@hosttuls.com> <3FD99121.9000702@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FD99121.9000702@ratnet.stw.uni-erlangen.de>
To: schmidt@naa.net, Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Norman Schmidt wrote:
> Brandon Evans schrieb:

For the record, the error I was getting was:

EXT3-fs: unable to read superblock
mount:error 22 mounting ext3

> Are you sure that the partition type is not set to fd?

Yes, they are all set to fd.


> Then the problem might be the older mechanism of RedHAT to start the raids.
> 
> Which bootloader do you use? I use lilo for my servers, that works with 
> root on raid1.

Thanks for all the info.  It will come in handy.

I was finally able to get the / partition to boot by switching the fs 
type from ext3 to ext2.

I was able to boot in ext2, I switched the fs back to ext3, rebooted, 
and now everything works fine.
I'm curious as to what happened there, but that question is for another 
list.





-- 
Thanks,
     Brandon E.
