From: "Al Boldi" <a1426z@gawab.com>
Subject: Multiplexed RAID-1 mode
Date: Sun, 31 Jul 2005 19:06:47 +0300
Message-ID: <200507311907.WAA07886@raad.intranet>
References: <Pine.LNX.4.56.0507310955400.3698@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0507310955400.3698@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Gordon Henderson' <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org, 'Jeff Breidenbach' <jeff@jab.org>
List-Id: linux-raid.ids

Gordon Henderson wrote: {
On Sat, 30 Jul 2005, Jeff Breidenbach wrote:
>
> I just ran a Linux software RAID-1 benchmark with some 500GB SATA 
> drives in NCQ mode, along with a non-RAID control. Details are here 
> for those interested.
>
>       http://www.jab.org/raid-bench/

The results you get are about what I get on various systems - essentially
with RAID-1 you get about the same speed as a single drive will get. 

ns1:/var/tmp# hdparm -tT /dev/md1 /dev/sda1 /dev/sdb1

/dev/md1:
 Timing cached reads:   4116 MB in  2.00 seconds = 2058.31 MB/sec
 Timing buffered disk reads:  174 MB in  3.00 seconds =  57.99 MB/sec

/dev/sda1:
 Timing cached reads:   4096 MB in  2.00 seconds = 2048.31 MB/sec
 Timing buffered disk reads:  176 MB in  3.03 seconds =  58.11 MB/sec

/dev/sdb1:
 Timing cached reads:   4116 MB in  2.00 seconds = 2057.28 MB/sec
 Timing buffered disk reads:  176 MB in  3.02 seconds =  58.27 MB/sec
}

Multiplexing read/write requests would certainly improve performance ala
RAID-0 (-offset overhead).
During reads the same RAID-0 code (+mirroring offset) could be used.
During writes though, this would imply delayed mirroring.

--
Al


