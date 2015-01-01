From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Thu, 01 Jan 2015 12:54:33 -0800
Message-ID: <54A5B409.8040501@tigertech.com>
References: <20150101174048.GB4840@deb76.aryehleib.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150101174048.GB4840@deb76.aryehleib.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/1/15 9:40 AM, Aryeh Leib Taurog wrote:

> I recently made a RAID1 array from a couple of extra usb drives:
> 
> $ mdadm --create --metadata 1.2 --verbose /dev/md/backup --level=mirror -n2 /dev/sd[cd]2

These are sdc2 and sdd2. Okay.


> Personalities : [raid1] 
> md126 : active (auto-read-only) raid1 sdc2[0]
>       943587136 blocks super 1.2 [2/1] [U_]
>       
> md127 : active (auto-read-only) raid1 sdd2[1]
>       943587136 blocks super 1.2 [2/1] [_U]

Still sdc2 and sdd2, although now in two arrays.


> AFAIK both drives are healthy, but since that happened, it refuses to 
> assemble them both in the array:
> 
> $ mdadm --assemble --force /dev/md/backup /dev/sd[db]2
> mdadm: ignoring /dev/sdb2 as it reports /dev/sdd2 as failed

Now you're working on sdb2 and sdd2. Is that intentional? Did sdc2
become sdb2 after a restart or something?


> Is there any way to put the array back together without having to 
> resync?

You should collect more data about what array each partition thinks it's
a member of, etc., before you try anything else. People can probably
help more if you report the output of these to the list:

 mdadm --detail /dev/md*
 mdadm --examine /dev/sd*

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
