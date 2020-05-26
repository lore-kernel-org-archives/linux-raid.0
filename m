From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Tue, 26 May 2020 16:37:48 -0700
Message-ID: <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl> <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl> <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl> <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl> <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 25, 2020 at 9:23 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 5/19/20 1:55 AM, Song Liu wrote:
> >
> > 2. try use bcc/bpftrace to trace r5l_recovery_read_page(),
> > specifically, the 4th argument.
> > With bcc, it is something like:
> >
> >      trace.py -M 100 'r5l_recovery_read_page() "%llx", arg4'
> >
> > -M above limits the number of outputs to 100 lines. We may need to
> > increase the limit or
> > remove the constraint. If the system doesn't have bcc/bpftrace. You
> > can also try with
> > kprobe.
> >
>
>
> Trace keeps outputting the following data (with steadily growing 4th
> argument):
>
> PID     TID     COMM            FUNC             -
> 3456    3456    mdadm           r5l_recovery_read_page 98f65b8
> 3456    3456    mdadm           r5l_recovery_read_page 98f65c0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65c8
> 3456    3456    mdadm           r5l_recovery_read_page 98f65d0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65d8
> 3456    3456    mdadm           r5l_recovery_read_page 98f65e0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65e8
> 3456    3456    mdadm           r5l_recovery_read_page 98f65f0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65f8
> 3456    3456    mdadm           r5l_recovery_read_page 98f6600
> 3456    3456    mdadm           r5l_recovery_read_page 98f65c0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65c8
> 3456    3456    mdadm           r5l_recovery_read_page 98f65d0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65d8
> 3456    3456    mdadm           r5l_recovery_read_page 98f65e0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65e8
> 3456    3456    mdadm           r5l_recovery_read_page 98f65f0
> 3456    3456    mdadm           r5l_recovery_read_page 98f65f8
> 3456    3456    mdadm           r5l_recovery_read_page 98f6600
> 3456    3456    mdadm           r5l_recovery_read_page 98f6608
> 3456    3456    mdadm           r5l_recovery_read_page 98f6610
>
> ... a few minutes later ...
>
> PID     TID     COMM            FUNC             -
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b60
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b68
>
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b70
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b78
>
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b80
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b88
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b90
>
>
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b98
> 3456    3456    mdadm           r5l_recovery_read_page 9b69ba0
> 3456    3456    mdadm           r5l_recovery_read_page 9b69ba8
>
>
> 3456    3456    mdadm           r5l_recovery_read_page 9b69bb0
>
>
> 3456    3456    mdadm           r5l_recovery_read_page 9b69bb8
> 3456    3456    mdadm           r5l_recovery_read_page 9b69bc0
>
> 3456    3456    mdadm           r5l_recovery_read_page 9b69bc8
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b90
>
>
> 3456    3456    mdadm           r5l_recovery_read_page 9b69b98
> 3456    3456    mdadm           r5l_recovery_read_page 9b69ba0
> 3456    3456    mdadm           r5l_recovery_read_page 9b69ba8
> 3456    3456    mdadm           r5l_recovery_read_page 9b69bb0
> 3456    3456    mdadm           r5l_recovery_read_page 9b69bb8
>
> ... and so on

Looks like the kernel has processed about 1.2GB of journal (9b69bb8 -
98f65b8 sectors).
And the limit is min(1/4 disk size, 10GB).

I just checked the code, it should stop once it hits checksum
mismatch. Does it keep going
after half hour or so?

Thanks,
Song
