From: Al Boldi <a1426z@gawab.com>
Subject: Re: raid1 does not seem faster
Date: Sun, 1 Apr 2007 15:58:31 +0300
Message-ID: <200704011558.31670.a1426z@gawab.com>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> normally, I'd think that combining drives into a raid1 array would give
> me at least a little improvement in read speed. In my setup however,
> this does not seem to be the case.
>
> 14:16 opteron:/var/log # hdparm -t /dev/sda
>  Timing buffered disk reads:  170 MB in  3.01 seconds =  56.52 MB/sec
> 14:17 opteron:/var/log # hdparm -t /dev/md3
>  Timing buffered disk reads:  170 MB in  3.01 seconds =  56.45 MB/sec
> (and dd_rescue shows the same numbers)

The problem is that raid1 one doesn't do striped reads, but rather uses 
read-balancing per proc.  Try your test with parallel reads; it should be 
faster.

You could use raid10, but then you loose single-disk-image compatibility.


Thanks!

--
Al
