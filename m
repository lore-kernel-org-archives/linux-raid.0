From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Thu, 12 Jun 2003 09:37:23 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00e901c330ad$158f1580$3351960a@EEL>
References: <02d201c33023$13fd45a0$3351960a@EEL> <3EE78458.4411C4B5@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Great,

Do you happen to know if this patch was included in the kernel? If so, at
what version?

I need to know how reliable it is.

Thanks a lot,
Ionut

----- Original Message ----- 
From: "Paul Clements" <Paul.Clements@SteelEye.com>
To: "Ionut Nistor" <ionut@modulo.ro>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, June 11, 2003 10:34 PM
Subject: Re: Multipath problem in a SAN enviromnent


> Ionut Nistor wrote:
>
> > I'm using a 2.4.18-ac3 kernel
>
> It just dawned on me that this kernel probably does not have the
> following patch applied:
>
> http://lwn.net/Articles/8485/
>
> If that's the case, you may want to move to a later kernel or apply that
> patch. I believe the patch will fix your issues with the shifting minor
> numbers causing problems.
>
> I did a brief test on SuSE's 2.4.19 kernel, which has this patch
> applied, and everything worked, even after shifting devices around.
>
> --
> Paul
>

