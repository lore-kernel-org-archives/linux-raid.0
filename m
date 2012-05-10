From: Phil Turmel <philip@turmel.org>
Subject: Re: Unable to set chunk size
Date: Thu, 10 May 2012 11:23:10 -0400
Message-ID: <4FABDD5E.5000103@turmel.org>
References: <CAGA5_H5c4+9s9OSyQaAxbekfTBDqAsR=y2GJRtO0AdChJTrZNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA5_H5c4+9s9OSyQaAxbekfTBDqAsR=y2GJRtO0AdChJTrZNQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rajasekhar Pulluru <pullururajasekhar@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/10/2012 10:23 AM, Rajasekhar Pulluru wrote:
> Hi All,
> 
> I am unable to set chunk size for a raid5 device.
> # cat /sys/block/md0/md/chunk_size
> 1048576
> # echo 4194304 > /sys/block/md0/md/chunk_size
> # cat /sys/block/md0/md/chunk_size
> 1048576
> 
> What could be the problem?

That sysfs parameter is read-only.  You set the chunk size when you
create the array, or use "mdadm --grow" to reshape it.

HTH,

Phil
