From: Thomas Harold <thomas-lists@nybeta.com>
Subject: Re: data scrubbing
Date: Fri, 29 Jul 2011 13:17:24 -0400
Message-ID: <4E32EB24.7010909@nybeta.com>
References: <4E327445.9080404@oldum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E327445.9080404@oldum.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <hijacker@oldum.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/29/2011 4:50 AM, Nikolay Kichukov wrote:
> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>
> Hi all,
>
> Recently on this list it was discussed it is a good practice to
> perform data scrubbing for some raid levels. Can someone advise what
> raid levels need that operation scheduled on a regular basis? Perhaps
> all raid arrays that have:
>
> /sys/block/md*/md/sync_action
>
> [sync_action] property?
>
> For example is it good for raid1 array?
>

Yes, we run a script every week (different arrays on different nights)
that looks like:

#!/bin/sh

echo check > /sys/block/md0/md/sync_action
mdadm --wait /dev/md0
cat /sys/block/md0/md/mismatch_cnt

