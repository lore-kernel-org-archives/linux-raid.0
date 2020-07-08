From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Wed, 8 Jul 2020 16:51:56 -0700
Message-ID: <CAPhsuW6tzdneY9C7kiZTC-qhK-se_JhY2e683PQo09QvAqyP6Q@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <49efa0d2-b44c-ec85-5e44-fb93a15001e7@yandex.pl> <4df42e3d-ad2b-dfc2-3961-49ada4ea7eaf@yandex.pl>
 <CAPhsuW5kk0G9PSfEADc8+rn=QT2z4ogjuV98qWsH_s_WBic-5w@mail.gmail.com>
 <71f58507-314e-4a1d-dd50-41a60d76521b@yandex.pl> <CAPhsuW59Q7mU9WH36RHs9kb-TMk7FmrQL+JCApupf_TZtpWynA@mail.gmail.com>
 <4a03e900-61a8-f150-9be8-739e88ba8ce6@yandex.pl> <CAPhsuW4BZE-DeESsq-coNx5_KZrfHjP=d9YOjOPqPji5kQBXjg@mail.gmail.com>
 <a772ede5-1d6f-e7cd-e949-a5d81d0fdbd1@yandex.pl> <CAPhsuW5hwAMTy8ozpsT+n5F3M7NzKqBdheFZvnouZEv8hEqAxQ@mail.gmail.com>
 <4b426e56-f971-67cf-81c0-63e035bf492a@yandex.pl> <CAPhsuW6fvgRCz7X7nnCEof4+yy2fTsxShNCuqTkMC0JQpj6gKw@mail.gmail.com>
 <57247f5e-ec38-fb8c-9684-abbe699945fb@yandex.pl> <CAPhsuW4hnpsbhQWWNKqgnw4nhp4Ho+gFbPU2fGjoMOcM8y7L+Q@mail.gmail.com>
 <15a3dd66-39a9-894d-3e72-d231cf36758e@yandex.pl> <4577498e-4124-ac6f-9d76-1f039fa1ba80@yandex.pl>
 <CAPhsuW4Y-23m7JexbnUCO3pq6+yTNrMrN6v-od+FFzZU8PgCdA@mail.gmail.com> <40054126-5009-3633-b7f9-198c2cc53ce7@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40054126-5009-3633-b7f9-198c2cc53ce7@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 8, 2020 at 4:29 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 7/7/20 12:08 AM, Song Liu wrote:
> >>
> >> So, what kind of next step after this ?
> >
> > Sorry for the delay. I read the log again, and found the following
> > line caused this issue:
> >
> > [ +16.088243] r5l_write_super_and_discard_space set MD_SB_CHANGE_PENDING
> >
> > The attached patch should workaround this issue. Could you please give it a try?
>
> Yea, this solved the issue - the raid assembled correctly (so the patch
> is probably a good candidate for lts kernels).

Thanks for testing the patch. I will work on applying it to upstream.

>
> Thanks for helping with this bug.
>
> Underlying filesystems are mountable/usable as well - albeit read-only
> fsck (ext4) or btrfs check do find some minor issues; tough to say at
> this point what was the exact culprit.
>
> In this particular case - imho - one issue remains: the assembly is
> slower than full resync (without bitmap), which outside of some
> performance gains (writeback journal) and write-hole fixing - kind of
> completely defeats the point of having such resync policy in the first
> place.

Totally agreed that we need to improve the recovery speed. I will also look
into that.

Thanks again!
Song
