From: <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Tue, 28 Apr 2009 14:36:48 -0500
Message-ID: <20090428193646633.CKYO19475@cdptpa-omta01.mail.rr.com>
References: <20090424100349002.RBNT6537@cdptpa-omta02.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090424100349002.RBNT6537@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > Quad core Xeon 2.8GHz md RAID6 of 16 x 750GB. Delete 20GB file:
> >
> > time rm -f dump
> >
> > real    0m1.849s
> > user    0m0.000s
> > sys     0m1.633s
> 
> 3.2 GHz AMD Athlon 64 x 2 RAID6 of 10 x 1T:
> 
> RAID-Server:/RAID/Recordings# ll sizetest.fil
> -rw-rw-rw- 1 lrhorer users 27847620608 2009-04-24 03:21 sizetest.fil
> RAID-Server:/RAID/Recordings# time rm sizetest.fil
> 
> real    0m21.503s
> user    0m0.000s
> sys     0m6.852s
> 
> See what I mean?  'Zero additional activity on the array other than the rm
> task.  We'll see what happens with XFS.

So far, it's looking much better.  I'll test it again when the array is
closer to being full.

RAID-Server:/RAID/Recordings# ll testfile
-rw-rw-rw- 1 lrhorer users 12506679296 2009-04-25 03:29 testfile
RAID-Server:/RAID/Recordings# time rm testfile

real    0m0.111s
user    0m0.000s
sys     0m0.000s

