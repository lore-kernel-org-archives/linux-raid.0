From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PULL request]  md fixes for 2.6.36
Date: 7 Oct 2010 08:47:11 -0400
Message-ID: <20101007124711.12080.qmail@science.horizon.com>
References: <20101007125756.15d5d5c8@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101007125756.15d5d5c8@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, torvalds@linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux@horizon.com, maciej.rutecki@gmail.com, segooon@gmail.com
List-Id: linux-raid.ids

> Hi Linus,
> It turns out there is a regression:
>     https://bugzilla.kernel.org/show_bug.cgi?id=19642
>
> that was my fault.
> The first of these three patches (avoid overflow...) fixes it.

Just a confirmation that the patch series (I didn't try them one at
a time) fixes the regression.  I'd also like to agitate for inclusion
in 2.6.36.

Thank you very much; this was obviously a slightly obscure bug!
