From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: raid6check extremely slow ?
Date: Tue, 12 May 2020 03:52:50 +0200
Message-ID: <CAOxFTcyj6-8PJwrhfCptZkOPW7iciQOUxuazCcAUnXgnD-d3kg@mail.gmail.com>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
 <20200511064022.591C5240E1A@gemini.denx.de> <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com>
 <20200511161415.GA8049@lazy.lzy> <CAOxFTcyH8ET=DXsm7RQ3eVbxg+6g+nX-apwahBejniGz1QR2+g@mail.gmail.com>
 <59cd0b9f-b8ac-87c1-bc7e-fd290284a772@cloud.ionos.com> <d350c913-0ec6-c1a2-fb41-1fa0dec6632f@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d350c913-0ec6-c1a2-fb41-1fa0dec6632f@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 11, 2020 at 11:16 PM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
> On 5/11/20 11:12 PM, Guoqing Jiang wrote:
> > On 5/11/20 10:53 PM, Giuseppe Bilotta wrote:
> >> Would it be possible/effective to lock multiple stripes at once? Lock,
> >> say, 8 or 16 stripes, process them, unlock. I'm not familiar with the
> >> internals, but if locking is O(1) on the number of stripes (at least
> >> if they are consecutive), this would help reduce (potentially by a
> >> factor of 8 or 16) the costs of the locks/unlocks at the expense of
> >> longer locks and their influence on external I/O.
> >>
> >
> > Hmm, maybe something like.
> >
> > check_stripes
> >
> >     -> mddev_suspend
> >
> >     while (whole_stripe_num--) {
> >         check each stripe
> >     }
> >
> >     -> mddev_resume
> >
> >
> > Then just need to call suspend/resume once.
>
> But basically, the array can't process any new requests when checking is

Yeah, locking the entire device might be excessive (especially if it's
a big one). Using a granularity larger than 1 but smaller than the
whole device could be a compromise. Since the =E2=80=9Cno lock=E2=80=9D app=
roach seems
to be about an order of magnitude faster (at least in Piergiorgio's
benchmark), my guess was that something between 8 and 16 could bring
the speed up to be close to the =E2=80=9Cno lock=E2=80=9D case without havi=
ng dramatic
effects on I/O. Reading all 8/16 stripes before processing (assuming
sufficient memory) might even lead to better disk utilization during
the check.

--=20
Giuseppe "Oblomov" Bilotta
