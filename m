From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Thu, 28 May 2020 08:06:37 -0700
Message-ID: <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl> <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl> <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl> <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl> <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl> <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
 <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl> <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 28, 2020 at 3:18 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>
> On 5/27/20 3:36 PM, Michal Soltys wrote:
> > On 5/27/20 1:37 AM, Song Liu wrote:
> >>
[...]

> To expand on the above (mdadm was started yesterday):
>
> - it went on for ~19+ hours - like previously
> - the last piece in trace output:
>
> xs22:/home/msl=E2=98=A0 tail -n 4 trace.out ; echo
> 09:08:12 40739   40739   mdadm           r5l_recovery_read_page 1852d8b0
> 09:08:12 40739   40739   mdadm           r5l_recovery_read_page 1852d8b8
> 09:08:12 40739   40739   mdadm           r5l_recovery_read_page 1852d8c0
> 09:08:12 40739   40739   mdadm           r5l_recovery_read_page 1852d8c8
>
> So it went through ~120gb of journal (the journal device is 256gb).

This (processing more than 10GB) should not happen. So there must be
something wrong...

> Non-assembling raid issue aside (assuming it's unrelated) - why does it
> take such enormous amount of time ? That's average of like 1.7mb/s

This is slow because we are processing 4kB at a time. But it is slower than
my expectation. What are the speeds measured at boot? Something like the
following in dmesg:

[    3.851064] raid6: avx2x4   gen() 17328 MB/s
[    3.877404] raid6: avx2x4   xor() 11033 MB/s
[    3.903410] raid6: avx2x2   gen() 14710 MB/s
[    3.929410] raid6: avx2x2   xor()  8921 MB/s
[    3.955408] raid6: avx2x1   gen() 12687 MB/s
[    3.981405] raid6: avx2x1   xor()  8414 MB/s
[    4.007409] raid6: sse2x4   gen()  9105 MB/s
[    4.033403] raid6: sse2x4   xor()  5724 MB/s
[    4.059408] raid6: sse2x2   gen()  7570 MB/s
[    4.085410] raid6: sse2x2   xor()  4880 MB/s
[    4.111409] raid6: sse2x1   gen()  6484 MB/s
[    4.137402] raid6: sse2x1   xor()  4412 MB/s

For the next step, could you please try the following the beginning of
--assemble
run?

   trace.py -M 10 'r::r5l_recovery_verify_data_checksum()(retval !=3D 0)'

Thanks,
Song

PS: Some key functions here are inlined and thus not easily traceable. We w=
ill
probably need to patch the kernel for further debugging.

>
> Around 09:08 today, the recovery line popped in the dmesg as previously:
>
> [May27 12:58] md: md124 stopped.
> [  +0.006779] md/raid:md124: device sdf1 operational as raid disk 0
> [  +0.006929] md/raid:md124: device sdj1 operational as raid disk 3
> [  +0.006903] md/raid:md124: device sdi1 operational as raid disk 2
> [  +0.006914] md/raid:md124: device sdh1 operational as raid disk 1
> [  +0.007426] md/raid:md124: raid level 5 active with 4 out of 4
> devices, algorithm 2
> [May28 09:08] md/raid:md124: recovering 24667 data-only stripes and
> 50212 data-parity stripes
