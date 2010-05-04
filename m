From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 00/28] md patches destined for -next and the next
 merge  window
Date: Tue, 4 May 2010 13:01:38 +1000
Message-ID: <20100504130138.2137f953@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
	<s2se9c3a7c21005021059l5f708347u8d1b936440161b1a@mail.gmail.com>
	<20100503131116.459bdc7f@notabene.brown>
	<h2re9c3a7c21005030827xad33d108jede23a2036734f4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h2re9c3a7c21005030827xad33d108jede23a2036734f4d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 3 May 2010 08:27:04 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, May 2, 2010 at 8:11 PM, Neil Brown <neilb@suse.de> wrote:
> > On Sun, 2 May 2010 10:59:02 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >> A few fixes/enhancements while playing with the takeover code are =
available at:
> >>
> >> =C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git f=
or-neil
> >
> > Thanks - they all make sense.
> > I've merged them with my queue and push them to my for-next branch.
>=20
> Ok, thanks, and this one below on the 'fixes' branch...?
>=20
> >> I'd like to get "raid6: fix recovery performance regression" in fo=
r
> >> 2.6.34. =C2=A0I pushed it out to the url below, let me know if you=
 just
> >> want me to send it directly.

Sorry, I didn't notice this line before.
Yes, just send it directly.
I consider crypto/async_tx to be your domain.  I'm happy to know whats =
going
on in there but don't think that I need to be on the path into the kern=
el.

Thanks,
NeilBrown


> >>
> >> =C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git f=
ixes
> >>
> >> Dan Williams (1):
> >> =C2=A0 =C2=A0 =C2=A0 raid6: fix recovery performance regression
> >>
> >> =C2=A0crypto/async_tx/async_raid6_recov.c | =C2=A0 21 ++++++++++++=
+--------
> >> =C2=A01 files changed, 13 insertions(+), 8 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
