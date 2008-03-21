From: Maurice Hilarius <maurice@harddata.com>
Subject: Verifying spare drive, best practices
Date: Thu, 20 Mar 2008 22:35:04 -0600
Message-ID: <47E33AF8.6020106@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Given this situation:
7 disks in total
RAID5 of 6 disks, and a hot spare.

mdadm show the 6 disks, but not the spare.

As a maintenance question, where one wants to periodically ensure that 
the hot spare is both available and good.
How should one best :
1) Verify the hot spare is still available.
2) Verify that the hot spare is healthy?

-- 
With our best regards,

//Maurice W. Hilarius         Telephone: 01-780-456-9771/
/Hard Data Ltd.                FAX:          01-780-456-9772/
/11060 - 166 Avenue         email:maurice@harddata.com/
/Edmonton, AB, Canada         http://www.harddata.com//
/     T5X 1Y3/
/

