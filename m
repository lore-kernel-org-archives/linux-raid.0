From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Measuring RAID-0 CPU load
Date: Mon, 08 Mar 2004 12:44:50 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <404CB112.4F42F431@SteelEye.com>
References: <404CAA28.6030502@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ian Pilcher <i.pilcher@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ian Pilcher wrote:
> 
> I need to quantify the additional CPU load that RAID-0 adds (vs. the
> boost in I/O performance).  I don't need to do anything fancy;
> 'dd if=/dev/zero of=/dev/md?" should do the trick, but I'm not sure how
> to track the processor utilization during the run.
> 
> Any ideas?

pericles:~ # sar  -o /tmp/datafile 1 10000 &
[1] 23533
pericles:~ # 
pericles:~ # while :; do /bin/true; done
^C
pericles:~ # date
Mon Mar  8 12:41:01 EST 2004
pericles:~ # kill %1
pericles:~ # sar -f /tmp/datafile 
Linux 2.6.3-rc2 (pericles)      03/08/04

12:39:08          CPU     %user     %nice   %system     %idle
12:39:10          all      0.00      0.00      0.50     99.50
12:40:26          all      1.76      0.00      2.81     95.43
12:40:27          all      0.00      0.00      0.99     99.01
12:40:38          all     20.70      0.00     33.64     45.66
12:40:39          all      0.00      0.00      0.99     99.01
12:40:55          all      0.06      0.00      0.06     99.88
12:40:57          all      0.00      0.00      0.00    100.00
12:40:58          all     15.00      0.00     24.00     61.00
12:40:59          all     39.00      0.00     61.00      0.00
12:41:00          all     40.00      0.00     60.00      0.00
12:41:01          all      0.00      0.00      1.00     99.00
12:41:02          all      0.99      0.00      0.99     98.02
12:41:03          all      0.00      0.00      0.00    100.00
12:41:05          all      0.00      0.00      0.00    100.00
12:41:07          all      0.00      0.00      0.00    100.00
Average:          all      3.82      0.00      6.13     90.05

--
Paul
