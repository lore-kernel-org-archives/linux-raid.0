From: Andrew Walrond <andrew@walrond.org>
Subject: Re: RAID1 & 2.6.9 performance problem
Date: Mon, 17 Jan 2005 16:24:47 +0000
Message-ID: <200501171624.47645.andrew@walrond.org>
References: <41EBD827.80701@pipi.ma.cx> <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 17 January 2005 15:39, Gordon Henderson wrote:
> On Mon, 17 Jan 2005, Janusz Zamecki wrote:
>
> > I've expected much better /dev/md6 performance (at least 100MB/s).
>
> I wouldn't - use RAID-0 if you want more performance.
>

FWIW I get these results with RAID-0

andrew@orac ~ $ sudo hdparm -t /dev/sda /dev/sdb /dev/md0

/dev/sda:
 Timing buffered disk reads:  170 MB in  3.00 seconds =  56.64 MB/sec

/dev/sdb:
 Timing buffered disk reads:  170 MB in  3.02 seconds =  56.37 MB/sec

/dev/md0:
 Timing buffered disk reads:  236 MB in  3.02 seconds =  78.08 MB/sec

