From: Drew <drew.kay@gmail.com>
Subject: Re: mdadm does not create partition devices whatsoever,
 "partitionable" functionality broken
Date: Sat, 14 May 2011 06:27:14 -0700
Message-ID: <BANLkTin0qRZXYzWBTXUJqdHmaQR_p1VfUA@mail.gmail.com>
References: <4DCD4A83.8060202@pulseforce.com> <4DCD6119.3080705@turmel.org>
 <4DCD67EF.1070602@pulseforce.com> <4DCD6B27.70402@pulseforce.com>
 <20110513234055.4307c536@natsu> <4DCD72AF.1070809@pulseforce.com>
 <4DCD75FE.8010703@turmel.org> <4DCD7E78.6050000@pulseforce.com>
 <4DCD84E1.3040704@turmel.org> <20110514013221.552dc8ef@natsu>
 <iqlkfg$1s9$1@dough.gmane.org> <20110514162427.143668d6@natsu> <iqlu6n$duh$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iqlu6n$duh$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm sure that LV's could be defragmented - there is already code to m=
ove
> them around on the disks (such as to move them out of a PV before del=
eting
> the PV). =C2=A0I don't know why it hasn't been implemented - maybe th=
ere are too
> few people working on LVM, or that it is a low priority, or that LV
> fragmentation makes very little measurable difference in practice.

I've always figured it was because fragmentation in the LV's caused
little performance degradation. If we were talking about LV's composed
of hundreds of fragments I would expect to see degradation but I've
never come across a scenario where LV's have been that bad.

Someone refered to DOS in an earlier post and I think that's a good
example of relevance. I maintain a bunch of Windows based machines at
work and I did some performance benchmarking between a traditional
defrag utility and some of the "professional" versions. Bells and
whistles aside, what set most of the Pro versions apart from the
standard defrag utilities was the concept of "good enough" defrag,
which basically puts files into several larger fragments as opposed to
a complete defrag. I ran tests on filesystem performance before and
after defraging drives with both options and the change in performance
between a full defrag and a "good enough" defrag was minimal.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
