From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Raid 6 Fail Event
Date: Sun, 16 Nov 2014 15:39:56 +0000
Message-ID: <em16d8035c-84ce-4b71-bcbb-b5c965e35b04@littlez>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am new to MDADM and have just experienced my first device fail on my 
raid 6.

I am wondering if someone might be able to help by outlining a proper 
protocol for troubleshooting and rebuilding this array (proc/mdstat 
below).

Here is how I might approach it:

- remove the device
- test the device
- if the device tests OK then re add the device
- if the device fails, then replace the device
- resync

Thank-you for your consideration.

Best,

- Justin

Here is the mdstat email

-----------------

This is an automatically generated mail message from mdadm
running on BigBlue

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sdh1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdh1[5](F) sdg1[4] sdf1[3] sde1[2] sdd1[1] sdb1[6] 
sdc1[0]
14650666880 blocks super 1.2 level 6, 128k chunk, algorithm 2 [7/6] 
[UUUUU_U]

unused devices: <none>


--------
Justin Stephenson
Creative Director/Motion Designer
416-900-6069
http://justinstephenson.com

