From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Mon, 28 Oct 2002 22:02:40 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021028210240.GB15779@unthought.net>
References: <20021022104522.GC24075@unthought.net> <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu> <20021022112401.GA26549@unthought.net> <004e01c27eaf$b6c11940$707ba8c0@YQDING>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <004e01c27eaf$b6c11940$707ba8c0@YQDING>
To: Yiqiang Ding <yqding@rasilient.com>
Cc: raid@ddx.a2000.nu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 28, 2002 at 10:27:46AM -0800, Yiqiang Ding wrote:
> I had the similar result with IDE drives through hpt374 controller. S=
till
> don't understand why a degraded system has better read performance.

Could you comment on the guesses I made below, relating to the chunk
size?

> > Other than that... Well, if the parity information is intact, the d=
isks
> > would need to skip the parity blocks when the array is read from
> > sequentially.  With a degraded array, the reads are all contiguous =
on
> > the disks - this could be a difference perhaps??
> >
> > What chunk size are you using?  And can you try a chunk size that i=
s an
> > order of magnitude bigger or smaller?   (might take some time to te=
st
> > this out).
> >
> > For example, if you use a 4k chunksize (I don't think you do, if my=
 last
> > guess holds), then try 128k.  If you are using 64k or above (which,
> > again, if I am guessing correctly, is probably more like what you'r=
e
> > using), then try 4k.

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
