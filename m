From: Maurice Hilarius <maurice@harddata.com>
Subject: best way to create RAID10 on an CentOS5 install
Date: Sat, 30 Jun 2007 02:05:30 -0600
Message-ID: <46860ECA.7050707@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all again.

Extending from an earlier question:
"deliberately degrading RAID1 to a single disk, then back again"

I got some useful answers, which I appreciate.

Taking this the next step, I want to create a RAID10 using 4 disks on a
CentOS install
I also want to be able to stop and remove a pair of disks periodically ,
so I ma y exchange them as backup media.
Then add new disks and re-start it.

First challenge I see is the actual RAID10 creation in the install.

Second challenge is the syntax to stop the (correct) pair of disks and
remove them, then re-add them and restart the array so that is re-synchs.

Can anyone lend me some syntax and tips please?


-- 

With our best regards,


Maurice W. Hilarius        Telephone: 01-780-456-9771
Hard Data Ltd.  FAX:       01-780-456-9772
11060 - 166 Avenue         email:maurice@harddata.com
Edmonton, AB, Canada       http://www.harddata.com/
   T5X 1Y3


