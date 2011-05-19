From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: check which disk is a problem
Date: Thu, 19 May 2011 13:20:12 +0200
Message-ID: <4DD4FCEC.3090209@uni-konstanz.de>
References: <201105191234.39391.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105191234.39391.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/19/2011 12:34 PM, Pol Hallen wrote:
> Hi folks :-)
>
> I've a raid6 sw on debian stable and a problem (!):
>
> cat /proc/mdstat
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdc1[0] sdf1[5] sdg1[4] sdh1[3] sdd1[1]
>        5860543744 blocks level 6, 64k chunk, algorithm 2 [6/5] [UU_UUU]
>
> so, I think /dev/sde is corrupted disk
>
> How identify this disk?
>

hdparm -tT /dev/sde
will make its lights flicker for about 5 seconds.

HTH,
Kay

