From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 1/2] super1.0 calculates max sectors in a wrong way
Date: Tue, 28 Jul 2020 19:51:19 -0700
Message-ID: <CAPhsuW4Vty+k1gS_Eiw7=2a+pGoPnGAS72wmt1U7PimeMnMWUQ@mail.gmail.com>
References: <1593503737-5067-1-git-send-email-xni@redhat.com>
 <1593503737-5067-2-git-send-email-xni@redhat.com> <CAPhsuW7WY7kQ77BKBqev2CVFPS63C7u0HtBqkB49XtbRCysWmg@mail.gmail.com>
 <9626595c-cdd8-f46d-629e-67f9b11d2b6a@redhat.com> <CAPhsuW5RAEb7i-VQ+MS0XfGKNyd=2_=VoGVjk2SU6A30cW9PKg@mail.gmail.com>
 <22684ab9-7c20-f0a3-4045-3357bbf53125@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22684ab9-7c20-f0a3-4045-3357bbf53125@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>
List-Id: linux-raid.ids

On Tue, Jul 28, 2020 at 6:15 PM Xiao Ni <xni@redhat.com> wrote:
>
>
>
> On 07/29/2020 08:43 AM, Song Liu wrote:
> >> Hi Song
> >>
> >> This calculation of bitmap is decided by mdadm. In mdadm super1.c
> >> choose_bm_space function,
> >> it uses this way to calculate bitmap space. Do I need to add comments
> >> here to describe this?
> >> Something like "mdadm function choose_bm_space decides the bitmap space"?
> > Thanks for the explanation.
> >
> > I merged the two patches, made some changes, and applied it to md-next. Please
> > let me know whether it looks good.
> >
> The function super_10_choose_bm_space can make people confused. All
> types of super1 calculate
> bitmap space in the same way (super1.0, 1.1 and 1.2). Could you change
> the function name to
> super_1_choose_bm_space?

Updated. Thanks!

Song
