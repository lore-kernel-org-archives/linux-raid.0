From: Martin T <m4rtntns@gmail.com>
Subject: calculating optimal chunk size for Linux software-RAID
Date: Fri, 7 Mar 2014 02:06:32 +0000
Message-ID: <CAJx5YvHVrWgcOCOh2q95RLcDcq5bkev0uqyStj=Op3DCjNhTGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am I correct that optimal chunk size is usually the size of the
average file read/written to disk divided by number of block devices
in RAID array storing the data? For example if the average file size
is 1024KiB and I have four disks in RAID1, then I should choose the
chunk size around 256KiB to get the optimal read performance? Or if I
have two drives in RAID0, then I should choose the chunk size 512KiB
instead? Or are there better methods/benchmarks to determine the
optimal chunk size for software-RAID? Last but not least, is there a
good utility which could help one to measure the average I/O
read/write size?


regards,
Martin
