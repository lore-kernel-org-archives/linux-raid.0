From: "Yiqiang Ding" <yqding@rasilient.com>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Mon, 28 Oct 2002 10:27:46 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004e01c27eaf$b6c11940$707ba8c0@YQDING>
References: <20021022104522.GC24075@unthought.net> <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu> <20021022112401.GA26549@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jakob Oestergaard <jakob@unthought.net>, raid@ddx.a2000.nu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had the similar result with IDE drives through hpt374 controller. Sti=
ll
don't understand why a degraded system has better read performance.

YQ
----- Original Message -----
=46rom: "Jakob Oestergaard" <jakob@unthought.net>
To: <raid@ddx.a2000.nu>
Cc: <linux-raid@vger.kernel.org>
Sent: Tuesday, October 22, 2002 3:24 AM
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?


> On Tue, Oct 22, 2002 at 12:49:41PM +0200, raid@ddx.a2000.nu wrote:
> >
> > On Tue, 22 Oct 2002, Jakob Oestergaard wrote:
> >
> > > I didn't follow the beginning of this thread, sorry.  Is this SCS=
I?
> >
> > Ide disks on 3ware 7850 using software raid5
>
> Ok.  Odd.
>
> My first guess would be that it's some master/slave IDE issue - but y=
ou
> are probably running all your disks as masters (one disk per channel)=
,
> right?
>
> Other than that... Well, if the parity information is intact, the dis=
ks
> would need to skip the parity blocks when the array is read from
> sequentially.  With a degraded array, the reads are all contiguous on
> the disks - this could be a difference perhaps??
>
> What chunk size are you using?  And can you try a chunk size that is =
an
> order of magnitude bigger or smaller?   (might take some time to test
> this out).
>
> For example, if you use a 4k chunksize (I don't think you do, if my l=
ast
> guess holds), then try 128k.  If you are using 64k or above (which,
> again, if I am guessing correctly, is probably more like what you're
> using), then try 4k.
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
