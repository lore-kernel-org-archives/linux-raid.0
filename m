From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 Performance
Date: Wed, 27 Jul 2016 15:26:17 +0100
Message-ID: <22424.50313.900162.715200@tree.ty.sabi.co.uk>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

First a terminology point: you are reporting a *speed* problem,
not a performance problem. My impression that you are getting
pretty good performance, given your hardware, configuration and
workload. The difference between "speed" and "performance" is
that the first is a simple rate of stuff done per unit of time,
the second is an envelope embodying several tradeoffs, among
them with cost. In your question you describe a low rate of
stuff done per unit of time. :-)

> Currently I am using 8 x 480GB Intel SSD in a RAID5, then LVM
> on top, DRBD on top, and finally iSCSI on top (and then used
> as VM raw disks for mostly windows VM's).

A very brave configuration, a shining example of the "syntactic"
mindset, according to which any arbitrary combination of
legitimate features must be fine :-).

First server DRBD primary disks:

> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdi               0.00     0.00    0.00    0.00     0.00 0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
> sda              78.00    59.00   79.00   86.00     0.74 0.52     15.55     0.02    0.15    0.20    0.09   0.15   2.40
> sdg              35.00    48.00   68.00   79.00     0.52 0.44     13.39     0.02    0.14    0.24    0.05   0.11   1.60
> sdf              46.00    65.00   86.00   98.00     0.76 0.58     14.96     0.03    0.17    0.09    0.24   0.09   1.60
> sdh              97.00    45.00   70.00  141.00     0.66 0.68     12.96     0.08    0.36    0.29    0.40   0.34   7.20
> sde             101.00    75.00   87.00   94.00     0.79 0.61     15.76     0.08    0.42    0.32    0.51   0.29   5.20
> sdb              85.00    54.00   94.00  102.00     0.84 0.56     14.62     0.01    0.04    0.09    0.00   0.04   0.80
> sdc              85.00    74.00   98.00  106.00     0.79 0.66     14.53     0.01    0.06    0.04    0.08   0.04   0.80
> sdd             230.00   199.00  266.00  353.00     2.19 2.11     14.24     0.18    0.28    0.23    0.32   0.16   9.60

Second server DRBD secondary disks:

> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdf              67.00    76.00   64.00  113.00     0.52 0.62    13.17     0.26    1.47    0.06    2.27   1.45  25.60
> sdg              39.00    61.00   50.00  114.00     0.35 0.56    11.38     0.45    2.76    0.08    3.93   2.71  44.40
> sdd              49.00    67.00   50.00  109.00     0.39 0.57    12.40     0.75    4.73    0.00    6.90   4.70  74.80
> sdh              55.00    54.00   52.00  104.00     0.42 0.51    12.12     0.81    5.21    0.23    7.69   5.13  80.00
> sde              67.00    67.00   75.00  129.00     0.56 0.65    12.13     0.94    4.59    0.69    6.85   4.24  86.40
> sda              64.00    76.00   58.00  109.00     0.48 0.61    13.29     0.84    5.03    0.21    7.60   4.89  81.60
> sdb              35.00    72.00   57.00  104.00     0.36 0.57    11.84     0.69    4.27    0.14    6.54   4.22  68.00
> sdc             118.00   144.00  228.00  269.00     1.39 1.50    11.92     1.21    2.43    1.88    2.90   1.50  74.40
> md1               0.00     0.00    0.00  260.00     0.00 1.70    13.38     0.00    0.00    0.00    0.00   0.00   0.00

> I've confirmed that the problem is that we have mixed two
> models of SSD (520 series and 530 series), and that the 530
> series drives perform significantly worse (under load) in
> comparison.

The queue sizes and waiting time on the second server are very
low (on a somewhat similar system using 4TB disks I see waiting
times in the 1-5 seconds range, not milliseconds).

The impression I get is that there is some issue with DRBD
latency, because the second server's storage seems to me very
underutilized. This latency may be related to the flash SSDs
that you are using, because by default DRBD uses the "C"
synchronization protocol. Probably if you switched to the "B" or
even "A" protocols speed could improve, maybe a lot, even if
performance arguably would be the same or much worse.

Thus the most likely issue here is the 'fsync' problem: for
"consumerish" SSDs barrier-writes are synchronous, because they
don't have a battery/capacitor-backed cache, and rather slow for
small writes, because of the large size of erase blocks, which
can be mitigated with higher over-provisioning. These have much
of the story:

  https://www.sebastien-han.fr/blog/2014/10/10/ceph-how-to-test-if-your-ssd-is-suitable-as-a-journal-device/
  https://www.redhat.com/en/resources/ceph-pcie-ssd-performance-part-1
  http://www.spinics.net/lists/ceph-users/msg25928.html

The 520s seem not too bad, but still a long way from the disks
with battery/capacity-backed cache.

> the actual work-load is small random read/write, with the
> writes causing the biggest load.

Here most of the wise comments from the reply from D Dimitru
apply, to summarize:

* Small writes are a challenging workload for DRBD, regardless
  of other issues.

* Small writes are a very challenging workload for flash SSDs
  without battery/capacitor-backed caches.

* Parity RAID is a bad idea in general, in particular for
  workloads with many small writes, for they amplify writes via
  RMW.

etc. etc. :-)
