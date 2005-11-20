From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: comparing FreeBSD to linux
Date: Sun, 20 Nov 2005 18:54:23 -0500
Message-ID: <200511202354.jAKNsOw25852@www.watkins-home.com>
References: <5d96567b0511200350x215f37a1r5185d7b188f37639@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0511200350x215f37a1r5185d7b188f37639@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Raz Ben-Jehuda(caro)'" <raziebe@gmail.com>, 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Raz Ben-Jehuda(caro)
> Sent: Sunday, November 20, 2005 6:50 AM
> To: Linux RAID Mailing List
> Subject: comparing FreeBSD to linux
> 
> I have evaluated which is better in terms cpu load when dealing with raid.
> FreeBSD vinum's or linux raid.
> When i issued a huge amount of io's read to linux raid i got 93% cpu
> load ( 7% idle),
> while i having 10% cpu load  ( 90% idle ) in the freebsd.

Maybe a silly question...  But is it 9.3 times faster under Linux?  :)
That would explain the 9.3 times increase in CPU load.

It is important that you are comparing the CPU load at the same disks rate,
or at least factor in the disk rate.

Guy

> 
> I need to switch to linux from freebsd. I am using in linux 2.6.6 kernel .
> is problem is a known issue in linux , is it fixed ?
> 
> --
> Raz
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

