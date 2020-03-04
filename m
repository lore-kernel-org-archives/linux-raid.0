From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable
 I/O
Date: Wed, 4 Mar 2020 16:53:09 -0600
Message-ID: <41094cf9-0e3f-e44e-7ec8-0ab433d574a1@suddenlinkmail.com>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
 <20200302102542.309e2d19@natsu>
 <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
 <20200302115141.1e796b7c@natsu>
 <c5d8e6d2-a572-5602-6562-795ea52168ac@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c5d8e6d2-a572-5602-6562-795ea52168ac@suddenlinkmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/02/2020 12:57 AM, David C. Rankin wrote:
> On 03/02/2020 12:51 AM, Roman Mamedov wrote:
>> Yes, replace the drive ASAP, and see if that solves it.
> 
> Will do, thank you!
> 

Drive replaced and rebuilding:

md4 : active raid1 sdc[3] sdd[2]
      2930135488 blocks super 1.2 [2/1] [_U]
      [>....................]  recovery =  1.5% (46390912/2930135488)
finish=276.0min speed=174102K/sec
      bitmap: 1/22 pages [4KB], 65536KB chunk

Things are looking good, speed=174102K/sec, which is a far-sight better than
speed=2022K/sec. This will give a 4.5 hour rebuild (instead of a 26 day
scrub). I suspect the virtualbox problems will disappear as well once the
rebuild is done.

Thank you to everyone for helping get me pointed in the right direction. I'll
let you know if I have any further issues here, but I don't anticipate any
(fingers-crossed...)

-- 
David C. Rankin, J.D.,P.E.
