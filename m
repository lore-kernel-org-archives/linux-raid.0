From: Michael <michael@rw23.de>
Subject: Re: =?UTF-8?Q?Slow=28=3F=29=20raid=35=20to=20raid=36=20reshape=20speed?=
Date: Tue, 16 Feb 2010 13:18:19 +0100
Message-ID: <afb99b76feb4fad30a4f43fb46ea3e4d@rw23.de>
References: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de> <alpine.DEB.1.10.1002161251570.4986@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002161251570.4986@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

here is the output. i have watched it

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3.87    0.00    2.23    8.52    0.00   85.38

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz
avgqu-sz   await  svctm  %util
sda             859.60   857.60   74.40   21.20 14192.00  7030.40   221.99
   0.98   10.33   6.35  60.72
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00
   0.00    0.00   0.00   0.00
sdd             831.40   840.60  100.40   43.20 14198.40  7070.40   148.11
   0.50    3.50   1.73  24.86
sdc             831.20   836.40  100.60   44.20 14198.40  7044.80   146.71
   0.51    3.52   1.81  26.14
sde               0.00     0.00    0.00   40.40     0.00 19673.60   486.97
   8.72  215.79   4.46  18.00
sdf             854.60   865.40   77.20   17.20 14174.40  7060.80   224.95
   1.28   13.61   4.95  46.72
sdg               0.00   854.80    0.20   27.80     1.60  7060.80   252.23
   0.69   24.60  11.17  31.28

a minute later (just to state another one):
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3.15    0.00    2.16   10.28    0.00   84.41

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz
avgqu-sz   await  svctm  %util
sda             811.60   813.80   92.20   16.60 16446.40  6643.20   212.22
   0.97    9.05   5.54  60.32
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00
   0.00    0.00   0.00   0.00
sdd             785.00   790.60  117.60   40.60 16436.80  6649.60   145.93
   0.47    2.98   1.50  23.66
sdc             785.80   791.20  116.80   40.00 16436.80  6649.60   147.23
   0.49    3.14   1.57  24.68
sde               0.00     0.00    0.00   45.20     0.00 21844.80   483.29
  10.51  197.05   4.38  19.80
sdf             809.00   815.60   94.80   14.60 16446.40  6641.60   211.04
   1.26   11.47   4.27  46.74
sdg               0.00   808.00    0.00   23.40     0.00  6651.20   284.24
   0.64   27.41  12.33  28.86

so this is not 100%, right?

On Tue, 16 Feb 2010 12:53:27 +0100 (CET), Mikael Abrahamsson
<swmike@swm.pp.se> wrote:
> On Tue, 16 Feb 2010, Michael wrote:
> 
>> i think the kernel's raid io is not visible at iotop or iam wrong?
> 
> Use "iostat -x 5" to see what is going on, personally I used 
> "sync_speed_min" so my drives were around 50-80% busy because for some 
> reason it tried to use much lower speed a otherwise.
> 
> If your drives are already at 100% then there is nothing more to do than

> to wait it out...
