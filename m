From: Maurice Hilarius <maurice@harddata.com>
Subject: couple of seemingly dumb questions
Date: Thu, 18 Apr 2002 22:48:14 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20020418224457.03d73910@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On software RAID/raidtools how does one change the rebuild priority on a 
replacement disk or resync?
I don't mind giving higher CPU priority, since in many cases the boxes I am 
using have lots more CPU than is being used most of the time.

Secondly:
With a software RAID5 setup, with disks in removable hot-swap trays, I want 
to be able to pull a failed disk and replace it and have it then rebuild. 
Problem is, when I pull the disk I get lots of error messages, and then 
when I replace it there is nothing happening to redetect that the disk is 
changed, and allow me to rebuild. If I reboot then the machine does resync 
with the new drive, but surely there must be a way without a reboot?

Thanks all for suggestions and info!

With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

Ask me about the UP1500 Alpha - Full systems from $3,500!

