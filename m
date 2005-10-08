From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: Re: Anybody know about nforce4 SATA II hot swapping + linux raid?
Date: Sat, 8 Oct 2005 11:01:25 -0400
Message-ID: <355e5e5e0510080801p88f04c7x7992c3d75f20e65c@mail.gmail.com>
References: <200510071111.46788.andrew@walrond.org>
	 <43477836.6020107@gmail.com>
	 <62b0912f0510080726ge2436e9ra6d7e8d17d1001ee@mail.gmail.com>
	 <200510081555.41159.andrew@walrond.org>
Reply-To: Lukasz Kosewski <lkosewsk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200510081555.41159.andrew@walrond.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org, Molle Bestefich <molle.bestefich@gmail.com>, htejun@gmail.com, linux-raid@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-raid.ids

On 10/8/05, Andrew Walrond <andrew@walrond.org> wrote:
> The lack of hot swapping does seem to be a serious weakness in linux, at least
> for resilient server applications. It would really complete the linux raid
> picture, and make it quite compelling.
>
> But I'm in no position to do it myself; I can only hope this thread inspires
> some capable person to plug the gap :)

Hey Andrew,

I've actually been working on implementing the core set of routines
that will allow for hot-swapping SATA drives in Linux.  The core is
not quite ready yet, but you can expect the next iteration within the
week.  Once the core is integrated, someone will have to implement
capturing hotswap events on the nForce4 SATA controller, and using the
core functions.  I don't know how long that will take, but if the
Linux SATA maintainer, Jeff Garzik (CCed on this email) knows how to
do it, then it might be just a few weeks' time.

That said, if you want to use this for servers you might still want to
wait a bit before committing your resources to this :)

Luke Kosewski
