From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Re: Online resize
Date: Tue, 11 Mar 2008 14:44:17 +0200
Message-ID: <200803111444.17502.wayne@flashmedia.co.za>
References: <200803111119.56015.wayne@flashmedia.co.za> <20080311111219.GA2086@cthulhu.home.robinhill.me.uk>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080311111219.GA2086@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well that didn't go so well

On Tuesday 11 March 2008 13:12:19 Robin Hill wrote:
> =A02) Force the OS to be aware of the new partition sizes - either a
> =A0 =A0 reboot or using partprobe.
> =A03) Grow the array (mdadm --grow) - check the manual page for detai=
ls.
I ran partprobe and then mdadm --grow --size=3Dmax /dev/md4 and nothing=
=20
happened. Then I decided to reboot thinking that partprobe hadn't picke=
d up=20
that change and now it says that sda6 doesn't have a superblock. Any id=
eas=20
what went wrong?

> =A04) Resize the filesystem (resize2fs).


--=20
Regards
Wayne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
