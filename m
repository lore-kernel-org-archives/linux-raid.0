From: "Yiqiang Ding" <yqding@rasilient.com>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Tue, 29 Oct 2002 13:05:59 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008c01c27f8e$fb63a3d0$707ba8c0@YQDING>
References: <20021022104522.GC24075@unthought.net> <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu> <20021022112401.GA26549@unthought.net> <004e01c27eaf$b6c11940$707ba8c0@YQDING> <20021028210240.GB15779@unthought.net> <006501c27eca$3a1f0440$707ba8c0@YQDING> <20021029003046.GE15779@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: raid@ddx.a2000.nu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jakob,

Thanks for your kind explanation. Sounds pretty reasonable. I also have=
 done
some tests on raid5 with 4k and 128k chunk size. The results are as fol=
lows:
Access Spec     4K(MBps)        4K-deg(MBps)    128K(MBps)
128K-deg(MBps)
2K Seq Read     23.015089       33.293993       25.415035       32.6692=
78
2K Seq Write    27.363041       30.555328       14.185889       16.0878=
62
64K Seq Read    22.952559       44.414774       26.02711        44.0369=
93
64K Seq Write   25.171833       32.67759        13.97861        15.6181=
26

Some conclusions:
1. "Degraded" raid5 has better (sequential) read/write performances. Th=
e
biggest difference is in 64k sequential read, almost doubled.
2. Bigger chunk size makes less difference between non-degraded and deg=
raded
RAID5. This is due to less seek penalty for bigger chunksize raid5 acco=
rding
to Jakob's theory.
3. Bigger chunk size makes worse write performance. Why? Maybe somebody=
 can
explain this.

YQ

----- Original Message -----
=46rom: "Jakob Oestergaard" <jakob@unthought.net>
To: "Yiqiang Ding" <yqding@rasilient.com>
Cc: <raid@ddx.a2000.nu>; <linux-raid@vger.kernel.org>
Sent: Monday, October 28, 2002 4:30 PM
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?


> On Mon, Oct 28, 2002 at 01:37:34PM -0800, Yiqiang Ding wrote:
> > Hi Jakob,
> >
> > I don't follow your guesses. Why do you think it may be related to =
chunk
> > size? Anyway, I'm using 32K.
>
> Because in RAID-5, each disk will hold blocks like:
>
> Disk 0:  [parity] [data]   [data]   [parity]
> Disk 1:  [data]   [parity] [data]   [data]
> Disk 2:  [data]   [data]   [parity] [data]
>
> So when reading blocks 0, 1, 2, 3, 4, ... from the array, we will do:
>
> Read disk 1 block 0
> Read disk 2 block 0
> Read disk 0 block 1
> Read disk 2 block 1
> Read disk 0 block 2
> Read disk 1 block 2
> Read disk 1 block 3
> Read disk 2 block 3
>
> We can do read-ahead, but the access pattern for disk 0 is:
>
> Block 1, block 2, block 4, ...
>
> For disk 1:
>
> Block 0, block 2, block 3, ...
>
> etc...
>
> So we introduce seeks, because of the parity blocks.
>
> Seeking ruins performance.
>
> In a degraded array, the kernel cannot skip the parity blocks, it mus=
t
> use them for calculating the lost data.
>
> So my guess is, that this "penalty" actually turns out to be an
> optimization (if the chunk size is small - eg. the number of seeks
> introduced is large). We will do strictly sequential reads on all dis=
ks.
>
> So tell me, have I been smoking something, or does this make sense?  =
:)
>
> Even better - measure degraded vs. non-degraded read performance on a
> RAID-5 array, first with chunk-size 4k, then 32k, then 128k, and post
> the results here   ;)
>
> --
> ................................................................
> :   jakob@unthought.net   : And I see the elder races,         :
> :.........................: putrid forms of man                :
> :   Jakob =D8stergaard      : See him rise and claim the earth,  :
> :        OZ9ABN           : his downfall is at hand.           :
> :.........................:............{Konkhra}...............:
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
