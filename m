From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Re: Online resize
Date: Wed, 12 Mar 2008 09:27:31 +0200
Message-ID: <200803120927.31646.wayne@flashmedia.co.za>
References: <200803111119.56015.wayne@flashmedia.co.za> <200803111444.17502.wayne@flashmedia.co.za> <20080311145832.GC2086@cthulhu.home.robinhill.me.uk>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080311145832.GC2086@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 11 March 2008 16:58:32 Robin Hill wrote:
> What version metadata are you using? =A0I'm not sure how 1.0 will han=
dle
> partition resizes but any other should certainly be okay. =A0
I'm not sure, the version in mdadm -E is 00.90.00. Is that what your ta=
lking=20
about? They were done at the same time.

> Have you tried running mdadm -E on each of the component partitions?
Yes, It just says "no md superblock detected on /dev/sda6". Same with t=
he=20
rest.

> I assume the new partitions are starting from the same position as th=
e old=20
ones?

Yes, I just dropped the partition and made a new one in place.



--=20
Regards
Wayne=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
