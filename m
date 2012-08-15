From: Andy Lutomirski <luto@amacapital.net>
Subject: O_DIRECT to md raid 6 is slow
Date: Tue, 14 Aug 2012 17:49:52 -0700
Message-ID: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If I do:
# dd if=/dev/zero of=/dev/md0p1 bs=8M
then iostat -m 5 says:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00   26.88   35.27    0.00   37.85

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb             265.20         1.16        54.79          5        273
sdc             266.20         1.47        54.73          7        273
sdd             264.20         1.38        54.54          6        272
sdf             286.00         1.84        54.74          9        273
sde             266.60         1.04        54.75          5        273
sdg             265.00         1.02        54.74          5        273
md0           55808.00         0.00       218.00          0       1090

If I do:
# dd if=/dev/zero of=/dev/md0p1 bs=8M oflag=direct
then iostat -m 5 says:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00   11.70   12.94    0.00   75.36

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb             831.00         8.58        30.42         42        152
sdc             832.80         8.05        29.99         40        149
sdd             832.00         9.10        29.78         45        148
sdf             838.40         9.11        29.72         45        148
sde             828.80         7.91        29.79         39        148
sdg             850.80         8.00        30.18         40        150
md0            1012.60         0.00       101.27          0        506

It looks like md isn't recognizing that I'm writing whole stripes when
I'm in O_DIRECT mode.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
