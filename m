From: vincent Ferrer <vincentchicago1@gmail.com>
Subject: raid5 to utilize upto 8 cores
Date: Wed, 15 Aug 2012 19:56:05 -0700
Message-ID: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

 Have questions  about making raid5  thread  use all the cores on my
linux based storage server !

- My  storage server  has upto 8 cores  running linux kernel 2.6.32.27.
- I created  a raid5 device of  10  SSDs .
-  It seems  I only have single raid5 kernel thread,  limiting  my
WRITE  throughput  to single cpu  core/thread.
Question :   What are my options to make  my raid5 thread use all the
CPU cores ?
                  My SSDs  can do much more but  single raid5 thread
from mdadm   is becoming the bottleneck.

To overcome above single-thread-raid5 limitation (for now)  I  re-configured.
     1)  I partitioned  all  my  10 SSDs into 8  partitions:
     2)  I created  8   raid5 threads. Each raid5 thread having
partition from each of the 8 SSDs
     3)  My WRITE performance   quadrupled  because I have 8 RAID5 threads.
Question: Is this workaround a   normal practice  or may give me
maintenance problems later on.


cheers
vincy F.
chico
