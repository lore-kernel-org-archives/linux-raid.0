From: "Guy" <bugzilla@watkins-home.com>
Subject: Odd md related top output with kernel 2.4.28
Date: Mon, 6 Dec 2004 01:41:55 -0500
Message-ID: <200412060642.iB66g0900966@www.watkins-home.com>
References: <20041205072652.GA30477@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041205072652.GA30477@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, (or anyone)
	I just upgraded my system from kernel 2.4.20.8smp (redhat) to 2.4.28
(from kernel.org).  I am making apache, and ran top to see how things were
going.  2 processes have strange info.  PIDs 8 and 28.  Any ideas about what
is going on?  The system seems fine.

Thanks,
Guy

From "ps -ef" they look like this:
root         8     1  0 Dec05 ?        00:00:00 [mdrecoveryd]
root        28     1  0 Dec05 ?        00:00:02 [raid5d]

98 processes: 95 sleeping, 3 running, 0 zombie, 0 stopped
CPU0 states:  62.1% user  11.0% system    0.0% nice   0.0% iowait  25.1%
idle
CPU1 states:  25.0% user  12.1% system    0.0% nice   0.0% iowait  62.0%
idle
Mem:   515296k av,  188588k used,  326708k free,       0k shrd,   22800k
buff
        36692k active,              84512k inactive
Swap:  524280k av,       0k used,  524280k free                   70264k
cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME CPU COMMAND
14574 root      13   0  2004 2004   960 R    24.9  0.3   0:00   0 sh
14562 root      16   0  1160 1160   856 R     6.4  0.2   0:00   1 top
14569 root       9   0   752  752   640 S     1.8  0.1   0:00   1 make
14571 root       9   0  1028 1028   888 S     0.9  0.1   0:00   1 sh
    1 root       9   0   472  472   424 S     0.0  0.0   0:03   1 init
    2 root       9   0     0    0     0 SW    0.0  0.0   0:00   0 keventd
    3 root      19  19     0    0     0 SWN   0.0  0.0   0:00   0
ksoftirqd_CPU
    4 root      19  19     0    0     0 SWN   0.0  0.0   0:00   1
ksoftirqd_CPU
    5 root       9   0     0    0     0 SW    0.0  0.0   0:00   1 kswapd
    6 root       9   0     0    0     0 SW    0.0  0.0   0:00   0 bdflush
    7 root       9   0     0    0     0 SW    0.0  0.0   0:00   1 kupdated
    8 root     18446744073709551615 -20     0    0     0 SW<   0.0  0.0
0:00
   14 root       9   0     0    0     0 SW    0.0  0.0   0:00   1 ahc_dv_0
   15 root       9   0     0    0     0 SW    0.0  0.0   0:00   0 ahc_dv_1
   16 root       9   0     0    0     0 SW    0.0  0.0   0:00   0 ahc_dv_2
   17 root       9   0     0    0     0 SW    0.0  0.0   0:00   1 ahc_dv_3
   18 root       9   0     0    0     0 SW    0.0  0.0   0:00   0 scsi_eh_0
   19 root       9   0     0    0     0 SW    0.0  0.0   0:00   1 scsi_eh_1
   20 root       9   0     0    0     0 SW    0.0  0.0   0:00   1 scsi_eh_2
   21 root       9   0     0    0     0 SW    0.0  0.0   0:00   1 scsi_eh_3
   28 root     18446744073709551615 -20     0    0     0 SW<   0.0  0.0
0:01

