From: "Yiqiang Ding" <yqding@rasilient.com>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Mon, 28 Oct 2002 13:37:34 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006501c27eca$3a1f0440$707ba8c0@YQDING>
References: <20021022104522.GC24075@unthought.net> <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu> <20021022112401.GA26549@unthought.net> <004e01c27eaf$b6c11940$707ba8c0@YQDING> <20021028210240.GB15779@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: raid@ddx.a2000.nu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jakob,

I don't follow your guesses. Why do you think it may be related to chun=
k
size? Anyway, I'm using 32K.

yq
----- Original Message -----
=46rom: "Jakob Oestergaard" <jakob@unthought.net>
To: "Yiqiang Ding" <yqding@rasilient.com>
Cc: <raid@ddx.a2000.nu>; <linux-raid@vger.kernel.org>
Sent: Monday, October 28, 2002 1:02 PM
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?


> On Mon, Oct 28, 2002 at 10:27:46AM -0800, Yiqiang Ding wrote:
> > I had the similar result with IDE drives through hpt374 controller.
Still
> > don't understand why a degraded system has better read performance.
>
> Could you comment on the guesses I made below, relating to the chunk
> size?
>
> > > Other than that... Well, if the parity information is intact, the
disks
> > > would need to skip the parity blocks when the array is read from
> > > sequentially.  With a degraded array, the reads are all contiguou=
s on
> > > the disks - this could be a difference perhaps??
> > >
> > > What chunk size are you using?  And can you try a chunk size that=
 is
an
> > > order of magnitude bigger or smaller?   (might take some time to =
test
> > > this out).
> > >
> > > For example, if you use a 4k chunksize (I don't think you do, if =
my
last
> > > guess holds), then try 128k.  If you are using 64k or above (whic=
h,
> > > again, if I am guessing correctly, is probably more like what you=
're
> > > using), then try 4k.
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
