From: Steven Haigh <netwiz@crc.id.au>
Subject: SMART, RAID and real world experience of failures.
Date: Fri, 06 Jan 2012 10:53:44 +1100
Message-ID: <4F063808.6040000@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Extremely long time listener but very few time poster.

I got a SMART error email yesterday from my home server with a 4 x 1Tb 
RAID6. It basically boiled down to:

The following warning/error was logged by the smartd daemon:
Device: /dev/sdd [SAT], 1 Currently unreadable (pending) sectors
Device: /dev/sdd [SAT], 1 Offline uncorrectable sectors

This got me wondering so I ran a long test (smartctl -t long /dev/sdd) 
and sure enough, after an hour or so I got this:

# 2  Extended offline    Completed: read failure       50%     17465 
      1172842872

So, in the spirit of experimentation, I did the following:
# mdadm /dev/md2 --manage --fail /dev/sdd
# mdadm /dev/md2 --manage --remove /dev/sdd
# dd if=/dev/zero of=/dev/sdd bs=10M
# mdadm /dev/md2 --manage --add /dev/sdd
< a resync occurred here, afterwards >
# smartctl -t long /dev/sdd
< long wait >
# smartctl -a /dev/sdd

This is where it gets interesting. Although it originally logged an 
error, I now see the following (with lots of other info trimmed):

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   4 Start_Stop_Count        0x0032   100   100   020    Old_age 
Always       -       154
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail 
Always       -       0
   9 Power_On_Hours          0x0032   081   081   000    Old_age 
Always       -       17493
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age 
Always       -       77
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age 
Offline      -       0

Then even more interesting:
SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     17489 
      -
# 2  Extended offline    Completed: read failure       50%     17465 
      1172842872

This makes me ponder. Has the drive recovered? Has the sector with the 
read failure been remapped and hidden from view? Is it still (more?) 
likely to fail in the near future?

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
