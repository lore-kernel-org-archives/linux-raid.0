From: linux@horizon.com
Subject: Re: Interesting RAID checking observations
Date: 21 Sep 2006 22:13:39 -0400
Message-ID: <20060922021339.31864.qmail@science.horizon.com>
References: <57360.192.168.0.1.1158864926.squirrel@bymeinc.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57360.192.168.0.1.1158864926.squirrel@bymeinc.com>
Sender: linux-raid-owner@vger.kernel.org
To: raid@bymeinc.com
Cc: linux-raid@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

> Check the I/O performance on the box. I think the "speed" indicator comes
> out of calculations to determine how fast a failing drive would be
> rebuilt, were you doing a rebuild instead of a check. I like using the
> "dstat" tool to get that info at-a-glance
> (http://dag.wieers.com/home-made/dstat/).

Thank you, you're quite right!  Running dtst during the check shows

--dsk/sda-----dsk/sdb-----dsk/sdc-----dsk/sdd-----dsk/sde-----dsk/sdf----dsk/total-
_read _writ:_read _writ:_read _writ:_read _writ:_read _writ:_read _writ:_read _writ
2954k   37k:2952k   36k:2954k   37k:2952k   35k:2955k   37k:2952k   35k:  17M  217k
  62M    0 :  62M    0 :  62M    0 :  62M    0 :  61M    0 :  62M    0 : 370M    0 
  62M    0 :  62M    0 :  62M    0 :  62M    0 :  62M    0 :  62M    0 : 372M    0 
  62M 8192B:  62M   76k:  62M   76k:  62M   36k:  62M   36k:  62M 8192B: 373M  240k
  47M 8192B:  47M 8192B:  47M 8192B:  47M 8192B:  47M 8192B:  47M 8192B: 283M   48k
  59M   16k:  59M   16k:  59M   16k:  59M  100k:  59M  100k:  59M   16k: 353M  264k
  63M    0 :  63M    0 :  63M    0 :  63M    0 :  63M    0 :  63M    0 : 378M    0 
  58M    0 :  58M    0 :  58M    0 :  58M    0 :  58M    0 :  58M    0 : 348M    0 
  57M    0 :  58M    0 :  58M    0 :  57M    0 :  58M    0 :  58M    0 : 345M    0 
  61M    0 :  61M    0 :  61M    0 :  61M    0 :  61M    0 :  61M    0 : 365M    0 
  61M    0 :  60M    0 :  60M    0 :  61M    0 :  60M    0 :  60M    0 : 363M    0 
  60M   16k:  60M   20k:  59M   20k:  59M   28k:  59M   28k:  60M   16k: 356M  128k

Whish is 60 MB/drive, exactly as expected.

On RAID-5, I could call it a "redundancy checking rate", but that doesn't
correspond to the RAID-1 numbers:

md0 : active raid1 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      979840 blocks [6/6] [UUUUUU]
      [==>..................]  resync = 14.3% (140480/979840) finish=0.4min speed=28096K/sec

Judging from dstat, that 28 MB/s figure is a per-drive.  (And I wonder
why *that* is so low.)


But anyway, good work on RAID-5!  Multi-way RAID-1 isn't economical on large
volumes of data, so it's hard to get very concerned about the speed.  I *can*
get > 60 MB/s per drive on 3 parallel 2-way RAID-1 checks.
