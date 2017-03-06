From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID Recovery
Date: Mon, 6 Mar 2017 16:36:55 +0100
Message-ID: <16fc386e-230e-9dbf-3b47-11400b3defc9@thelounge.net>
References: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 06.03.2017 um 16:07 schrieb Adam Goryachev:
> Hi all,
>
> I'm trying to assist a friend to recover their RAID array, it consists
> of 4 drives, most likely in RAID10. It was a linux based NAS (AFAIK). I
> would really appreciate any tips or suggestions...
>
> First, the bad news:
>
> mdadm --misc --detail /dev/sd[abcd]
> mdadm: /dev/sda does not appear to be an md device
> mdadm: /dev/sdb does not appear to be an md device
> mdadm: /dev/sdc does not appear to be an md device
> mdadm: /dev/sdd does not appear to be an md device

it's not uncommon to use partitions instead of whole drives

that below are two RAID10 and one RAID1 on four 2 TB drives and so 
/dev/sd[-d] are not an md-device

[root@rh:~]$ cat /proc/mdstat
Personalities : [raid1] [raid10]
md1 : active raid10 sda2[0] sdd2[2] sdb2[3] sdc2[1]
       30716928 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]

md0 : active raid1 sda1[0] sdd1[2] sdb1[3] sdc1[1]
       511988 blocks super 1.0 [4/4] [UUUU]

md2 : active raid10 sda3[0] sdd3[2] sdb3[3] sdc3[1]
       3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
