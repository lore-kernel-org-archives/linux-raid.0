From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: mdadm mail option configuration
Date: Sat, 1 Jun 2002 13:56:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020601135657.B22230@unthought.net>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F2633D2@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F6A3AFC9BCD92E48B79C14E4AAAEA20F2633D2@nonamea.ptu.promise.com>; from haofengk@ptu.promise.com on Fri, May 31, 2002 at 06:43:26PM -0700
To: Haofeng Kou <haofengk@ptu.promise.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 31, 2002 at 06:43:26PM -0700, Haofeng Kou wrote:
> I finish one linux driver and want to do the whole features testing for
> this driver, any body know certain tools for this testing ? It is a RAI=
D
> controller linux scsi driver.

You could run some disk benchmarks (tiotest, bonnie etc.)

The best test is of course when you get the driver into the kernel (it is
GPL right?) - then people will do all the testing for you   :)

--=20
................................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
