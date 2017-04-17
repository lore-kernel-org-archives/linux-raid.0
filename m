From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Lost second disk during resync, can I recover?
Date: Mon, 17 Apr 2017 08:40:40 +0200
Message-ID: <45fd34ce-08f3-e3e9-8f53-9cc2c26626c5@thelounge.net>
References: <CABM35JeXN_+coqggH4JDxCvvYAeqD4jt0FHHY=ykMMRofdQDJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABM35JeXN_+coqggH4JDxCvvYAeqD4jt0FHHY=ykMMRofdQDJQ@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Adam B <adam.backer@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 17.04.2017 um 02:30 schrieb Adam B:
> I've got a synology ds1812+
> Could have sworn I did raid 6, but md says raid5 (dont recall
> personalities pre-failure)
> Lost disk 2, was rebuilding and disk 6 crashed

> But nothing is happening, recovery-wise:
> 
> root@ds:~# mdadm -D /dev/md125
> /dev/md125:
>          Version : 1.2
>    Creation Time : Fri Oct 17 22:45:17 2014
>       Raid Level : raid5

if you lost 2 disks on RAID5 you are done
