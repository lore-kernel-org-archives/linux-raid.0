From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID10 reshape and change lout possible?
Date: Mon, 27 Feb 2017 08:42:09 +0800
Message-ID: <b573fbd3-0f37-7c37-0077-06e1140a34ef@fnarfbargle.com>
References: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/02/17 22:37, Reindl Harald wrote:
> since in recent news i saw that convert several raid-levels with respahe
> is possible now
>
> is it somehow possible to change a existing md RAID10 array from "2
> near-copies" to "2 far-copies" and what would be the mdadm syntax? the
> IO intense workload here are large reads within virtual disks and as far
> as i can see far-layout would here be the better option but as installed
> the stuff in 2011 not sure if anaconda even offered that in the OS
> installer

Far layout will significantly improve read performance, however it will 
also significantly impact write performance. You really want to spool up 
a test system and benchmark the performance in your specific application 
before considering changes like this. The write performance degradation 
on magnetic media is significant due to the extra seeking required.

As you've already discovered. It's a backup and restore exercise on RAID10.

Regards,
Brad
