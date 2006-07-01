From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Subject: Re: raid issues after power failure
Date: Sat, 01 Jul 2006 17:28:22 +0200
Message-ID: <44A69496.9030109@tyrell.hu>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>	<fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>	<49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>	<fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>	<fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>	<fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>	<Pine.LNX.4.63.0606300827570.30060@turos>	<fd8d0180606300540r3c957a7duf0c831917f55be7f@mail.gmail.com>	<Pine.LNX.4.63.0606300842430.30060@turos> <17573.44678.188170.409349@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17573.44678.188170.409349@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Francois Barre <francois.barre@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> Try adding '--force' to the -A line.
> That tells mdadm to try really hard to assemble the array.

thanks, this seems to have solved the issue...


Akos

