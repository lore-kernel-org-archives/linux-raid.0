From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Monitor Queue Depth for RAID-5 md device
Date: Sun, 25 Jan 2015 11:17:38 -0600
Message-ID: <CAB-428m9Za7Y3tdsrZ8Ck6wKg9T8S_03Ag25gu6rdsmaKxoNKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any way to monitor number of outstanding requests on the
raid-5 md device ?

I have a raid-5 array in /dev/md0 which contains /dev/sd[bcde] drives.
However, I don't always see 0 in avgqu-sz field of iostat utility:

 # iostat -xk 1 /dev/md0
Linux 3.13.0Write-Hole-Monitor (mist01-umh)     01/25/2015
_x86_64_        (8 CPU)
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.12    0.00    0.02    0.05    0.00   99.80
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
md0               0.00     0.00    0.00 15048.00     0.00 60192.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00

However, when I run iostats for actual devices (/dev/sd[bcde]) I can
see the queue depth. This is also true for some other fields like
%util:

# iostat -xk 1 /dev/sd[bcde]
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.40    0.00   15.44    0.00    0.00   84.17
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb            9463.00  9057.00  385.00  352.00 39304.00 37480.00
208.37     3.04    4.12    3.46    4.84   1.28  94.40
sde            8966.00  9592.00  355.00  376.00 37196.00 39388.00
209.53     2.88    3.93    3.37    4.46   1.27  93.20
sdd            9467.00  9098.00  374.00  361.00 39364.00 37516.00
209.20     2.75    3.73    3.38    4.09   1.25  92.00
sdc            9171.00  9339.00  368.00  369.00 38160.00 38512.00
208.07     3.21    4.34    3.76    4.92   1.27  93.60

In this example, there are 209 or 208 requests pending on the queue of
each device. Can I say that there is like 209 requests is pending on
the queue in the /dev/md0 device too ? In other word, take the maximum
value of the backend device queue depth as a queue depth of md device
?

Thanks
Alireza
