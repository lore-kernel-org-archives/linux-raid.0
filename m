From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Sat, 02 Mar 2013 03:06:30 +1100
Message-ID: <5130D206.4090302@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512A79D3.9020502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

No, sorry, I haven't curled up and died yet, and I am still working
through this. Things have somewhat calmed down, and I've tried not to
break anything more than it already is, as well as trying to catch up on
sleep.

So, I'm going to run through a quick summary of what has happened to
date, and at the end recap what I'm going to try and achieve this
weekend. Finally, I hope by the end of the weekend, it will run like a
dream :)

So, from the beginning (skip to the end if you remember this/get bored)

I had a SAN (called san1) server which was Debian Stable, with 5 x 480GB
Intel 520s MLC SSD's in a Linux md raid5 array.
On top of the RAID array is DRBD, (for the purposes of the rest of this
project/discussion, it is disconnected from the secondary).
On top of DRBD is LVM2, which divides up the space for each VM
On top of this is iet (iSCSI) to export each LV individually
The server had 4 x 1Gbps ethernet connected in round-robin to the
switch, plus 1 x 1Gbps ethernet for "management" and 1 x 1Gbps ethernet
crossover connection to the secondary DRBD which is in
disconnected/offline mode.

There are 8 Xen servers running Debian Testing, with a single 1Gbps
ethernet connection each, connected to the same switch as above.

Each xen server runs open-iscsi and logs into all available iSCSI
'shares'. This then appears as /dev/sdX which is passed as to the MS
Windows VM running on it (and it has the GPLPV drivers installed).

I was using the deadline scheduler, and it was advised to try changing
to noop, and disable NCQ (ie putting the driver in native IDE mode or
setting queue depth to 1).

I tried the noop in combination with stupidly:
echo 1 > /sys/block/sdb/queue/nr_requests
Which predictably resulted in poor performance. I reversed both
settings, and continued with the deadline scheduler.

At one stage I was asked to collect stats on the switch ports. I've now
done this, (just using mrtg with rrd, polling 5 minute intervals), for
both the 16 port switch with the user traffic and the 48 port switch
with the iSCSI traffic. This shows that at times, I can see the high
traffic on the Windows DC User LAN, and at the same time on the iSCSI
LAN ports for that xen box, and also a pair of LAN ports for the SAN1
box. However, what is interesting is
a) From about 9am to 5pm (minus a dip at lunch time) there is a
consistent 5Mbps to 10Mbps traffic on the user LAN port. This contrasts
with after hours backup traffic peaking at 15Mbps, (uses rsync for backup).
b) During 9am to 5pm, the pair of iSCSI LAN ports are not very busy,
sitting around 5 to 10Mbps each.
c) Tonight the backup started at 8pm, but from almost exactly 6pm, the
user LAN port was mostly idle, while the iSCSI SAN ports both were
running at 80 to over 100Mbps each.

(Remember these are 5 minute averages though...)

When checking the switch stats, I found no jumbo frames were in use.
Since then, the iSCSI LAN is fully jumbo frames enabled, and I do see
plenty of jumbo frames on the ports. The other switch with the user LAN
traffic does not have jumbo frames enabled, there are lots of machines
on the lan which do not support jumbo frames, including switches limited
to 10/100Mbps...

I was seeing a lot of Pause frames on the SAN ports and the windows DC
port.

I was getting delayed write errors from windows. I made the following
changes to resolve this:
a) Disable write cache on all windows machines, on all drives.
(including the Windows DC and Terminal Servers)
b) Installed multipath on the xen boxes, and configured it to queue on
iSCSI failure, this should cause a stall rather than a write failure.

I went backwards and forwards, and learned a lot about network
architecture, 802.3ad, LACP, bonding types, etc. Eventually, removed all
802.3ad configurations, removed roundrobin, and used balance-alb with
MPIO (to actually get more sessions to be able to scale up past a single
port). This isn't the final destination, but the networking side of
things now seems to be working really well/good enough.

One important point to note, is that 802.3ad or LACP on the switch side
meant inbound traffic all used the same link. In addition, Linux didn't
seem to balance outbound traffic well (it uses the mac address, or it
uses the IP address + port to decide which outbound port to use). In one
scenario, 1 of the 4 ports was unused, 1 was dedicated for 1 machine
each, one shared for 2 machines, and one shared for 5 machines. Very
poor balancing. Using balance-alb works MUCH better for traffic in both
directions to be much better balanced.

Even without any config, installing linux multipath and accessing the
same /dev/sdX device showed that Linux would now cache reads for iSCSI.
I did this, but I don't think it made much user level difference.

Have re-aligned my partitions on the 5 x SSD's to align optimally. This
didn't have much impact on performance anyway, but it was one thing to
tick off the list.

I was asked to supply photos of the mess of cabling, since I've now got
3 x 1Gbps ethernet for each of the 8 xen machines, plus 10 x 1Gbps
ethernet for each of the 2 SAN servers. That is a total of 48 cables
just for this set of 10 servers.... I did all cabling using "spare"
cables initially because I forgot I'd be needing a bunch of extra
cables. Once I ordered all new cables, I re-did it all, and also used
plenty of cable ties.
URL to photos will be sent to those who want to see them (off list....).
I'm pretty proud of my effort compared to the first attempt, but I'm
open to comments/suggestions on better cabling methods etc. I've used
Yellow cables to signify the iSCSI network, and blue for the "user"
network. Since they already used blue cables for the user networking
anyway....

Found a limitation in Linux that I couldn't login to more than 32
sessions within a short period of time. So using MPIO to login to 11
LUN's with 4 paths didn't work (44 logins at same time). Limited this to
2 paths, and this works properly.

Upgraded Linux kernel on the SAN1 machine to debian backports (3.2.x) to
bypass the REALLY bad performance for SSD's with the bug in 2.6.26
including the Debian stable version. The new kernel still doesn't solve
the 32 session iSCSI login limit.

Installed irqbalance to assist in balancing IRQ workload across all
available cores on SAN1

After all the above, complaints have fallen off, and are now generally
limited. I do still rarely see high IO load on the DC, and get a dozen
or so complaints from users. eg, there was very high load on the DC from
approx 3:45 to 4:10pm and at the same time I got a bunch of complaints.
I do get the few complaints about slow and stalling, but these are also
much less frequent but enough to be unsettling. I still think there is
some issue, since even these "high loads", they are not anywhere near
the capacity of the system. eg, 20MB/s is about 20 to 25% of what the
maximum capacity should be.




THINGS STILL TO TRY/DO
Could you please feel free to re-arrange the order of these, or let me
know if I should skip/not bother any of them. I'll try to do as much as
possible this weekend, and then see what happens next week.

1) Make sure stripe_cache_size is as least 8192.  If not:
~$ echo 8192 > /sys/block/md0/md/stripe_cache_size
Currently using default 256.

2) Disable HT on the SAN1, retest write performance for single threaded
write issue.
top -b -n 60 -d 0.25|grep Cpu|sort -n > /some.dir/some.file

3) fio tests should use this test config:
[global]
filename=/dev/vg0/testlv (assuming this is still correct)
zero_buffers
numjobs=16
thread
group_reporting
blocksize=256k
ioengine=libaio
iodepth=16
direct=1
size=8g

[read]
rw=randread
stonewall

[write]
rw=randwrite
stonewall

4) Try to connect the SSD's direct to the HBA, bypassing the hotswap
device in case this is limiting to SATA II or similar.

5) Configure the user LAN switch to prioritise RDP traffic. If SMB
traffic is flooding the link, than we need the user to at least feel
happy that the screen is still updating.

6) SAN1 - Get rid of the bond0 with 8 x 1G ports, and use 8 IP
addresses, (one on each port). Properly configure the clients to each
connect to a different pair of ports using MPIO.

7) Upgrade DRBD to 8.4.3
See https://blogs.linbit.com/p/469/843-random-writes-faster/

8) Lie to DRBD, pretend we have a BBU

9) Check out the output of xm top
I presume this is to ensure the dom0 CPU is not too busy to keep up with
handling the iSCSI/ethernet traffic/etc.

10) Run benchmarks on a couple of LV's on the san1 machine, if these
pass the expected performance level, then re-run on the physical
machines (xen). If that passes, then run inside a VM.

11) Collect the output from iostat -x 5 when the problem happens

12) disable NCQ (ie putting the driver in native IDE mode or setting
queue depth to 1).

I still haven't worked out how to actually do this, but now I'm using
the LSI card, maybe it is easier/harder, and apparently it shouldn't
make a lot of difference anyway.

13) Add at least a second virtual CPU (plus physical cpu) to the windows
DC. It is still single CPU due to the windows HAL version. Prefer to
provide a total of 4 CPU's to the VM, leaving 2 for the physical box,
same as all the rest of the VM's and physicals.

14) Upgrade windows 2000 DC to windows 2003, potentially there was some
xen/windows issue with performance. Previously I had an issue with
Win2003 with no service packs, and it was resolved by upgrade to service
pack 4.

15) "Make sure all LVs are aligned to the underlying md device geometry.
 This will eliminate any possible alignment issues."
What does this mean? The drive partitions are now aligned properly, but
how does LVM allocate the blocks for each LV, and how do I ensure it
does so optimally? How do I even check this?

16) RAID5:
md1 : active raid5 sdb1[7] sdd1[9] sde1[5] sdc1[8] sda1[6]
      1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5]
[UUUUU]
      bitmap: 2/4 pages [8KB], 65536KB chunk
Is it worth reducing the chunk size from 64k down to 16k or even smaller?

17) Consider upgrading the dual port network card on the DC box to a
4port card, use 2 ports for iSCSI and 2 ports for the user lan.
Configure the user lan side as LACP, so it can provide up to 1G for each
of 2 SMB users simultaneously. Means total 2Gbps for iSCSI and total
2Gbps for SMB, but only 1Gbps SMB for each user.

18) Ability to request the SSD to do garbage collection/TRIM/etc at
night (off peak)

19) Check IO size, seems to prefer doing a lot of small IO instead of
big blocks. Maybe due to drbd.

Thanks again to everyone's input/suggestions.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
