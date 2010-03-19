From: Joachim Otahal <Jou@gmx.net>
Subject: Re: BUG:write data to degrade raid5
Date: Fri, 19 Mar 2010 19:20:42 +0100
Message-ID: <4BA3C07A.8030204@gmx.net>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

jin zhencheng schrieb:
> hi;
>
> i use kernel is 2.6.26.2
>
> what i do as follow:
>
> 1, I create a raid5:
> mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
> --metadata=1.0 --assume-clean
>
> 2, dd if=/dev/zero of=/dev/md5 bs=1M&
>
> write data to this raid5
>
> 3, mdadm --manage /dev/md5 -f /dev/sda
>
> 4 mdadm --manage  /dev/md5 -f /dev/sdb
>
> if i faild 2 disks ,then the OS kernel display OOP error and kernel down
>
> do somebody know why ?
>
> Is MD/RAID5 bug ?
>    

RAID5 can only tolerate ONE drive to fail of ALL members. If you want to 
be able to fail two drives you will have to use RAID6 or RAID5 with one 
hot-spare (and give it time to rebuild before failing the second drive).
PLEASE read the documentation on raid levels, like on wikipedia.

Joachim Otahal

