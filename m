From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Fri, 29 May 2020 14:03:01 -0700
Message-ID: <CAPhsuW4oMKuCrHUU1ucsMKQbSfBQdsNEQWHA1SSbGR5nbvy21w@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl> <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl> <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl> <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl> <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl> <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
 <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl> <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
 <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com> <1767d7aa-6c60-7efb-bf37-6506f9aaa8a2@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1767d7aa-6c60-7efb-bf37-6506f9aaa8a2@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 29, 2020 at 5:09 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 5/28/20 5:06 PM, Song Liu wrote:
> >
> > For the next step, could you please try the following the beginning of
> > --assemble
> > run?
> >
> >     trace.py -M 10 'r::r5l_recovery_verify_data_checksum()(retval != 0)'
> >
> > Thanks,
> > Song
> >
>
> How long should I keep this one running ? So far - after ~1hr - nothing
> got reported.

We can stop it. It didn't really hit any data checksum error in early phase
of the recovery. So it did found a long long journal to recover.

Thanks,
Song
