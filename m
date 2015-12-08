From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Tue, 8 Dec 2015 13:38:54 -0600
Message-ID: <CAE9DZUSPPkbPTkkYJE7iHwK2Y95qTmeW87O5EHKBTR45_tsQrA@mail.gmail.com>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
	<20151202010745.GC9812@www5.open-std.org>
	<F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
	<565F03F2.3070803@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
	<565F1035.10800@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
	<565F136F.2090709@turmel.org>
	<CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
	<F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
	<566059E8.60804@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDE157@CFWEX01.americas.cray.com>
	<CAE9DZUTF3KBGoKVOX4u3+mii5imaVUfEj8kbNjfYMP=8=pHLQA@mail.gmail.com>
	<F7761B9B1D11B64BBB666019E9378117FE0BC3@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FE0BC3@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 7, 2015 at 8:29 AM, Robert Kierski <rkierski@cray.com> wrot=
e:
> I need some clarification on what data you want collected.... do you =
want iostat -xm collected before and after?  Or at a periodic interval =
(1 sec)?
>
> I'm measuring sustained performance.  This means I=E2=80=99m runnig f=
or a period of time -- 1 minute.  If you want iostat collected on an in=
terval, that would probably be more data than one would want posted to =
this mailing list.
>
> But... yes, this is a RAID6.
>
> I've switched to HDD's as storage as there is concern on the list tha=
t the DDR disk devices could be causing unintended behavior in RAID6.  =
With 6 HDD's, each able to do 270 MB/s on their outer edge, I'm getting=
 RAID6 throughput of about 1080 MB/s when I use a thread count of 4, us=
ing FIO.
>
> -----Original Message-----
> From: Dallas Clement [mailto:dallas.a.clement@gmail.com]
> Sent: Friday, December 04, 2015 10:08 AM
> To: Robert Kierski
> Cc: Phil Turmel; linux-raid@vger.kernel.org
> Subject: Re: RAID 5,6 sequential writing seems slower in newer kernel=
s
>
> Robert, is this with a RAID 6 array?  Also, what are the actual throu=
ghput numbers you are getting?  Would it be possible for you to capture=
 the iostat -xm output and report the individual disk wMB/s and also th=
e disk utilization for RAID 6?

Hi Robert.  Thanks for posting these results.  Your fio direct I/O
results look pretty darn good.  Were you able to confirm with hdparm
-t that you really can get 270 MB/s on your disks in reality?  Also,
what formula are you using to calculate best and worst case RAID 6
read and write speeds?

> However, when I increase TC to 5, my TP is only 750 MB/s.  When I inc=
rease TC to 32, my TP is about 250 MB/s.

Now this is pretty disappointing.  I agree, 12 cores should be able to
easily handle this number of threads.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
