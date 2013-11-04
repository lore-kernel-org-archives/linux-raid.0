From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [RFC] md raid resync counter
Date: Mon, 04 Nov 2013 10:26:42 +0100
Message-ID: <52776852.3020309@gmail.com>
References: <5273A5BC.5060109@gmail.com> <20131102104808.47834bdc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131102104808.47834bdc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/02/2013 12:48 AM, NeilBrown wrote:
> On Fri, 01 Nov 2013 13:59:40 +0100 Jack Wang <xjtuwjp@gmail.com> wrote:
> 
>> Hi Neil and all,
>>
>> Is there anyway to know:
>>
>> 1. How often does a raid start to resync?
> 
> Look at your logs?
> 
>> 2. How many bytes did it resync?
> 
> Look at "mismatch_cnt" in sysfs (and multiply by 512).
> 
> NeilBrown
> 
>
Thanks Neil,

You're always very helpful :)

About the second one. As I checked in my system kernel 3.4.51

when raid is resync:
cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 dm-1[3] dm-2[2]
      23762944 blocks super 1.2 [2/1] [_U]
      [==>..................]  recovery = 10.7% (2562240/23762944)
finish=7.5min speed=46565K/sec
# cat /sys/block/md1/md/mismatch_cnt
0

cat /sys/block/md1/md/degraded
1
 cat /sys/block/md1/md/mismatch_cnt
0
# cat /sys/block/md1/md/sync_completed
8911488 / 47525888

mismatch_cnt is 0, sync_completed look what I want?

Jack

