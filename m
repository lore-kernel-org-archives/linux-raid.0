From: Spelic <spelic@shiftmail.org>
Subject: mdadm incremental failed: md device busy
Date: Wed, 15 Dec 2010 18:50:11 +0100
Message-ID: <4D08FFD3.9040406@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi there
this happened:

# cat /proc/mdstat
...other arrays not including sdb3...
md2 : active raid1 sda3[0]
       52428728 blocks super 1.2 [2/1] [U_]
       bitmap: 6/200 pages [24KB], 128KB chunk
...other arrays not including sdb3...

strangely sdb3 was not added to array at boot, I am still investigating 
that, but now see this:

# mdadm --incremental /dev/sdb3
mdadm: failed to open /dev/md2: Device or resource busy.


#strace mdadm --incremental /dev/sdb3
...lots of stuff, then...
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
nanosleep({0, 200000000}, NULL)         = 0
open("/dev/md2", O_RDWR|O_EXCL)         = -1 EBUSY (Device or resource busy)
........
write(2, "mdadm: failed to open /dev/md2: "..., 57mdadm: failed to open 
/dev/md2: Device or resource busy.
) = 57


hmmm... strange thing, I just booted and md2 is not even mounted...
but now see this:

# mdadm /dev/md2 --add /dev/sdb3
mdadm: re-added /dev/sdb3

worked perfectly!

So?
Bug?

Thank you
