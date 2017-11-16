From: Larkin Lowrey <llowrey@gmail.com>
Subject: Re: [PATCH 2/2] mdadm: remove journal with "remove-journal"
Date: Thu, 16 Nov 2017 12:35:06 -0500
Message-ID: <24a446c5-18bd-bcfe-02a4-ec569dc572a5@gmail.com>
References: <63717f4b-5b81-7290-5265-087713f0bd45@nuclearwinter.com>
 <20170831175101.2965834-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170831175101.2965834-1-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
Cc: shli@kernel.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

Is it not possible to permanently remove a journal and return to resync 
mode?

Here's what I tried:

#  mdadm --readonly /dev/md124

# cat /proc/mdstat
Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
md124 : active (read-only) raid5 md123[7] md127p4[15](J) sdp1[13] 
sdl1[10] sdg1[12] sdf1[11] sdo1[14] sdj1[8] sdq1[9] md122[6]
       62509129728 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[9/9] [UUUUUUUUU]

# mdadm /dev/md124 --fail /dev/md127p4
mdadm: set /dev/md127p4 faulty in /dev/md124

# mdadm /dev/md124 --remove /dev/md127p4
mdadm: hot removed /dev/md127p4 from /dev/md124

# cat /sys/block/md124/md/consistency_policy
journal

# echo resync > /sys/block/md124/md/consistency_policy

# cat /sys/block/md124/md/consistency_policy
resync

# mdadm --stop /dev/md124
mdadm: stopped /dev/md124

# mdadm --assemble /dev/md124 /dev/md12[23] /dev/sd[goqpjfl]1
mdadm: Not safe to assemble with missing or stale journal device, 
consider --force.

--Larkin

On 8/31/2017 1:51 PM, Song Liu wrote:
> Hi Larkin,
>
> We didn't ship this patch. Instead, we decide to use sysfs entry
>
> /sys/block/mdXXX/md/consistency_policy
>
> You can find the patch at:
>
> https://marc.info/?l=linux-raid&m=149063896208043
>
> Thanks,
> Song
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

