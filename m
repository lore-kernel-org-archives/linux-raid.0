From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: stacked raid devices not autodetected?
Date: Mon, 6 Dec 2004 14:16:26 +0100
Message-ID: <20041206131626.GT3858@marowsky-bree.de>
References: <912C966151E990A5186A8A78@pcmy.sei.cmu.edu> <51419.164.129.1.39.1102088099.squirrel@164.129.1.39> <20041206113752.GM3858@marowsky-bree.de> <20041206114923.GF4693@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041206114923.GF4693@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-12-06T12:49:24, Luca Berra <bluca@comedia.it> wrote:

> >>> Is this a bug?  A design limitation?  Something else?
> >>this is one of the limitations of the in-kernel autodetection
> >You can pull a fix for that one out of the SUSE kernel, where we add=
 md
> >devices we just started to the auto detection. It worked pretty well=
 in
> >2.4, but my memory is hazed when I try to recall whether it was all
> >ported to 2.6...
> >
> is it worth doing that in-kernel, i really believe that identifying
> and starting arrays is a job that is better done in user-space.

I'm not disagreeing, I'm only pointing out that it is possible and what
the general fix looks like. We had a customer requirement to get it don=
e
that way, and at the time it was just the fastest way to code it.

I'm a fan of moving discovery to user-land, alas I'm also a fan of fran=
k
words and right now the much hailed user-space discovery of RAIDs,
partitions etc still has a couple of months to go to stabilize ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
