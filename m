From: Aaron Sowry <aaron@cendio.se>
Subject: RAID10 Performance
Date: Wed, 02 Mar 2011 10:04:19 +0100
Message-ID: <4D6E0813.1070903@cendio.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have been testing different RAID configurations on a 2-disk setup, and
have a couple of questions regarding performance. The information I have
found online so far seems to contradict itself fairly regularly so I was
hoping for a more coherent answer :)

1) As I understand it, a RAID10 'near' configuration using two disks is
essentially equivalent to a RAID1 configuration. Is this correct?

2) Does md RAID1 support 'striped' reads? If not, is RAID1 read
performance in any way related to the number of disks in the array?

3) From what I have read so far, a RAID10 'far' configuration on 2 disks
provides increased read performance over an equivalent 'near'
configuration, however I am struggling to understand exactly why. I
understand the difference between the 'near' and 'far' configurations,
but not *why* this should provide any speed increases. What am I missing?

4) I have performed a(n admittedly fairly basic) benchmark on the same
system under two different configurations - RAID10,n2 and RAID10,f2
using tiobench with default settings. In short, the results showed a
significant speed increase for single-threaded sequential reads (83Mb/s
vs 166MB/s), some increase for single-threaded random reads (1.85Mb/s vs
2.25Mb/s), but a decrease for every other metric, including
multi-threaded sequential and random reads. I was expecting write
performance to decrease under RAID10,f2 compared to RAID10,n2, but am
slightly confused about the multi-threaded read performance. Is it my
expectations or my testing that needs to be reviewed?

Cheers,
Aaron
