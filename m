From: NeilBrown <neilb@suse.de>
Subject: Re: possible bug - bitmap dirty pages status
Date: Thu, 1 Sep 2011 15:40:22 +1000
Message-ID: <20110901154022.45f54657@notabene.brown>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
	<CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
	<CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
	<4E5E2F7D.1010306@anonymous.org.uk>
	<CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com>
	<CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com>
	<CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Paul Clements <paul.clements@us.sios.com>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 1 Sep 2011 00:16:36 +0400 CoolCold <coolthecold@gmail.com> wrot=
e:

> On Wed, Aug 31, 2011 at 6:08 PM, Paul Clements
> <paul.clements@us.sios.com> wrote:
> > On Wed, Aug 31, 2011 at 9:16 AM, CoolCold <coolthecold@gmail.com> w=
rote:
> >
> >> =A0 =A0 =A0 =A0 =A0Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
> >>
> >> And 16/22 lasts for 4 days.
> >
> > So if you force another resync, does it change/clear up?
> >
> > If you unmount/stop all activity does it change?
> Well, this server is in production now, may be i'll be able to do
> array stop/start later..right now i've set "cat /proc/mdstat" every
> minute, and bitmap examine every minute, will see later is it changin=
g
> or not.
>=20

I spent altogether too long staring at the code and I can see various t=
hings
that could be usefully tidied but but nothing that really explains what=
 you
have.

If there was no write activity to the array at all I can just see how t=
hat
last bits to be set might not get cleared, but as soon as another write
happened all those old bits would get cleared pretty quickly.  And it s=
eems
unlikely that there have been no writes for over 4 days (???).

I don't think having these bits here is harmful and it would be easy to=
 get
rid of them by using "mdadm --grow" to remove and then re-add the bitma=
p,
but I wish I knew what caused it...

I clean up the little issues I found in mainline and hope there isn't a
larger problem luking behind all this..

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
