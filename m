From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Tue, 29 Oct 2002 01:30:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021029003046.GE15779@unthought.net>
References: <20021022104522.GC24075@unthought.net> <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu> <20021022112401.GA26549@unthought.net> <004e01c27eaf$b6c11940$707ba8c0@YQDING> <20021028210240.GB15779@unthought.net> <006501c27eca$3a1f0440$707ba8c0@YQDING>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <006501c27eca$3a1f0440$707ba8c0@YQDING>
To: Yiqiang Ding <yqding@rasilient.com>
Cc: raid@ddx.a2000.nu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 28, 2002 at 01:37:34PM -0800, Yiqiang Ding wrote:
> Hi Jakob,
>=20
> I don't follow your guesses. Why do you think it may be related to ch=
unk
> size? Anyway, I'm using 32K.

Because in RAID-5, each disk will hold blocks like:

Disk 0:  [parity] [data]   [data]   [parity]
Disk 1:  [data]   [parity] [data]   [data]
Disk 2:  [data]   [data]   [parity] [data]

So when reading blocks 0, 1, 2, 3, 4, ... from the array, we will do:

Read disk 1 block 0
Read disk 2 block 0
Read disk 0 block 1
Read disk 2 block 1
Read disk 0 block 2
Read disk 1 block 2
Read disk 1 block 3
Read disk 2 block 3

We can do read-ahead, but the access pattern for disk 0 is:

Block 1, block 2, block 4, ...

=46or disk 1:

Block 0, block 2, block 3, ...

etc...

So we introduce seeks, because of the parity blocks.

Seeking ruins performance.

In a degraded array, the kernel cannot skip the parity blocks, it must
use them for calculating the lost data.

So my guess is, that this "penalty" actually turns out to be an
optimization (if the chunk size is small - eg. the number of seeks
introduced is large). We will do strictly sequential reads on all disks=
=2E

So tell me, have I been smoking something, or does this make sense?  :)

Even better - measure degraded vs. non-degraded read performance on a
RAID-5 array, first with chunk-size 4k, then 32k, then 128k, and post
the results here   ;)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
