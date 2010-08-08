From: Tomasz Chmielewski <tch@wpkg.org>
Subject: cciss_vol_status can't decide if it has a broken array or not
Date: Sun, 08 Aug 2010 23:22:18 +0200
Message-ID: <4C5F200A.8010001@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm trying to monitor hardware RAID status on HP ProLiant DL180 G6 with "cciss_vol_status" tool.

Unfortunately, on some of my servers it can't decide if the array is healthy or not (or, the spares in it).

For example, it outputs the following failures about the spares:

# cciss_vol_status /dev/cciss/*

/dev/cciss/c0d0: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d0: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive has failed.
    Total of 1 failed physical drives detected on this logical drive.
/dev/cciss/c0d0: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.
/dev/cciss/c0d0p1: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d0p1: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive has failed.
    Total of 1 failed physical drives detected on this logical drive.
/dev/cciss/c0d0p1: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.
/dev/cciss/c0d0p2: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d0p2: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive has failed.
    Total of 1 failed physical drives detected on this logical drive.
/dev/cciss/c0d0p2: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.
/dev/cciss/c0d1: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d1: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive has failed.
    Total of 1 failed physical drives detected on this logical drive.
/dev/cciss/c0d1: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.



But start it again short after "the failed run", and it will report no failures at all:

# cciss_vol_status /dev/cciss/*
/dev/cciss/c0d0: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d0: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive remains available.
/dev/cciss/c0d0: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.
/dev/cciss/c0d0p1: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d0p1: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive remains available.
/dev/cciss/c0d0p1: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.
/dev/cciss/c0d0p2: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d0p2: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive remains available.
/dev/cciss/c0d0p2: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.
/dev/cciss/c0d1: (Smart Array P410) RAID 1 Volume 0 status: OK. 
/dev/cciss/c0d1: (Smart Array P410) RAID 5 Volume 1 status: OK.   At least one spare drive designated.  At least one spare drive remains available.
/dev/cciss/c0d1: (Smart Array P410) Enclosure DL18xG6BP (S/N: ) on Bus 0, Physical Port 1I status: OK.


Wait a few minutes, it will report failures.

Is it expected? Are my spares failing or not?

I'm running 64 bit Debian Lenny (2.6.26 kernel).


PS. is there a better list for Linux hardware RAID issues?


-- 
Tomasz Chmielewski
http://wpkg.org

