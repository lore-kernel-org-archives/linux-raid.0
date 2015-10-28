From: Andras Tantos <andras@tantosonline.com>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 28 Oct 2015 10:10:47 -0700
Message-ID: <56310197.1010708@tantosonline.com>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
 <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
 <562D5F91.5040300@turmel.org> <5630F862.5040308@tantosonline.com>
 <5630FB05.5070902@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5630FB05.5070902@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil,

 >> To be able to re-assemble the array, I *have* to specify metadata
 >> version 0.9:
 >>
 >> Is this a problem? Can I upgrade my array to 1.0 metadata? Should I?
 >
 > Hmm. Interesting.  Your version of mdadm is insisting on reserving much
 > more space between end of content and the v1.0 metadata than when using
 > v0.90 metadata.
 >
 > I'm curious how much.  Please show the output of "cat /proc/partitions".

root@bazsalikom:/home/tantos# cat /proc/partitions
major minor  #blocks  name

    8       16 1465138584 sdb
    8       17 1465136001 sdb1
    8       48 1465138584 sdd
    8       49 1465136001 sdd1
    8       80 1465138584 sdf
    8       81 1465136001 sdf1
    8       96 1953513527 sdg
    8       97 1953512001 sdg1
    8      112 1953514584 sdh
    8      113     538145 sdh1
    8      114 1465138552 sdh2
    8      115  487837854 sdh3
    8       64 1953514584 sde
    8       65     538145 sde1
    8       66 1465138552 sde2
    8       67  487837854 sde3
    8       32 1953514584 sdc
    8       33     538145 sdc1
    8       34 1465138552 sdc2
    8       35  487837854 sdc3
    9        0  487837760 md0
    9        1 7325679680 md1

Andras

