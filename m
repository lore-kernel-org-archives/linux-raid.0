From: "Peter Sangas" <psangas@warren-selbert.com>
Subject: Read data from disk that was part of RAID1 array
Date: Thu, 16 Mar 2017 15:18:29 -0700
Message-ID: <008801d29ea3$3e858000$bb908000$@warren-selbert.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My setup:

Linux green 4.4.0-47-generic #68-Ubuntu SMP Wed Oct 26 19:39:52 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux
Ubuntu 16.04.2 LTS

mdadm -V
mdadm - v3.3 - 3rd September 2013


I have only one disk from a RAID1 array and I would like to read data from
one of the partitions.  This there a way to mount this and read the data?

Thanks,
Pete


