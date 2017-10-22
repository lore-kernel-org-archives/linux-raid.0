From: sfunk1x <sfunk1x@gmail.com>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Sun, 22 Oct 2017 14:00:48 -0700
Message-ID: <78c21efa-2587-6ff3-5572-2d1a1b6d428d@gmail.com>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
 <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
 <59E7AE4B.5000903@youngman.org.uk>
 <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
 <87zi8mg7mi.fsf@notabene.neil.brown.name>
 <e257fcc8-9773-a8a2-42bd-6030aef6329e@gmail.com>
 <87efpyfuz6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efpyfuz6.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/19/2017 06:50 PM, NeilBrown wrote:

> Thanks.  sdf looks like it might have a gpt partition
> table on it.  The "od -x" supports that.  What does "fdisk -l /dev/sdf"
> show? What about 
>   mdadm --examine /dev/sdf*
> ??

fdisk -l /dev/sdf:

Disk /dev/sdf: 3000.6 GB, 3000592982016 bytes, 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: gpt
Disk identifier: 5B742241-93F1-4FE1-9CA6-525F759E38B1


#         Start          End    Size  Type            Name
 1         2048   5860533134    2.7T  Linux RAID


mdadm --examine /dev/sdf*

/dev/sdf:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
mdadm: No md superblock detected on /dev/sdf1.



> 
> I should have suggested " | head" at the end of the 'grep'
> command.  Maybe make it
>   od -x /dev/sdf | grep '4efc a92b' | head
> That will look for md metadata.

It's actually still running, but this is the output so far:

[root@hemlock ~]# od -x /dev/sdf | grep '4efc a92b' | head
142401762260 7984 d854 643a 3c8f dd3a a8de 4efc a92b
156441541400 48f9 9523 3539 de0a d1f4 4efc a92b 60a8
214717071120 ac68 a62e 441c c0f8 85c1 cab7 4efc a92b
367526264660 dc8f 4f52 4efc a92b fd99 4744 1d6e c59f
515240166540 4f6a c1eb 5309 4efc a92b d0ad b3ee 11a0
575452271660 b669 7eeb 4efc a92b ebf5 c069 c78d 82d3
1026007653000 913f 4efc a92b 0b3d 5e94 9f7a 80a5 6e0c
1104130763160 7267 f0e5 e9a4 a9e0 0b85 5b3b 4efc a92b
1107535224640 cde4 efa8 557c 01a1 1abb b885 4efc a92b
1167200747300 49dd f3e2 4efc a92b a6e7 f1af 7af1 e6c6


