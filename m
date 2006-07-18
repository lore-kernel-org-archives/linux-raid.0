From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: mdadm -X bitmap status off by 2^16
Date: Tue, 18 Jul 2006 11:30:42 -0400
Message-ID: <44BCFEA2.20301@steeleye.com>
References: <priv$efbe06145625$36d67b3763@200607.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <priv$efbe06145625$36d67b3763@200607.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Farkas <chexum+dev@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janos Farkas wrote:

> # for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
>           Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
>           Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
>           Bitmap : 285923 bits (chunks), 65536 dirty (22.9%)

This indicates that the _on-disk_ bits are cleared on two disks, but set 
on the third.


> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md0 : active raid5 hdd3[2] hdb3[0] hda3[1]
>       585569024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 0/140 pages [0KB], 1024KB chunk

This indicates that the _in-memory_ bits are all cleared.

At array startup, md initializes the in-memory bitmap from the on-disk 
copy. It then uses the in-memory bitmap from that point on, shadowing 
any changes there into the on-disk bitmap.

At the end of a rebuild (which should have happened after you added the 
third disk), the bits should all be cleared. The on-disk bits get 
cleared lazily, though. Is there any chance that they are cleared now? 
If not, it sounds like a bug to me.

--
Paul
