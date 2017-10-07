From: Alexander Shenkin <al@shenkin.org>
Subject: SMART detects pending sectors; take offline?
Date: Sat, 7 Oct 2017 08:48:09 +0100
Message-ID: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

My SMART monitoring has picked up some pending sectors on one of my
RAID0 + RAID5 drives (it's one of the infamous 3TB seagate drives... my
other 3 failed earlier... this is the last of them, that finally has
gone as well...).  I've just ordered a replacement (Toshiba P300) that
will arrive tomorrow... but the question is, what to do in the meantime?
 Should I take the drive offline?  I suspect so, but would like to
double check before taking action.  Thanks in advance for any advice.

Here are the errors:


The following warning/error was logged by the smartd daemon:

Device: /dev/sda [SAT], Self-Test Log error count increased from 0 to 1

Device info:
ST3000DM001-9YN166, S/N:Z1F13FBA, WWN:5-000c50-04e444ab1, FW:CC4B, 3.00 TB

------------------

The following warning/error was logged by the smartd daemon:

Device: /dev/sda [SAT], 8 Offline uncorrectable sectors

Device info:
ST3000DM001-9YN166, S/N:Z1F13FBA, WWN:5-000c50-04e444ab1, FW:CC4B, 3.00 TB

-----------------

The following warning/error was logged by the smartd daemon:

Device: /dev/sda [SAT], 8 Currently unreadable (pending) sectors

Device info:
ST3000DM001-9YN166, S/N:Z1F13FBA, WWN:5-000c50-04e444ab1, FW:CC4B, 3.00 TB


Thanks,

Allie
