From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Thu, 28 May 2020 17:36:33 +0200
Message-ID: <0ee953db-9db9-e839-2f56-74ba0ddb3e86@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl>
 <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl>
 <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl>
 <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl>
 <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl>
 <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
 <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl>
 <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
 <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/28/20 5:06 PM, Song Liu wrote:
> On Thu, May 28, 2020 at 3:18 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
> 
> This is slow because we are processing 4kB at a time. But it is slower than
> my expectation. What are the speeds measured at boot? Something like the
> following in dmesg:
> 
> [    3.851064] raid6: avx2x4   gen() 17328 MB/s
> [    3.877404] raid6: avx2x4   xor() 11033 MB/s
> [    3.903410] raid6: avx2x2   gen() 14710 MB/s
> [    3.929410] raid6: avx2x2   xor()  8921 MB/s
> [    3.955408] raid6: avx2x1   gen() 12687 MB/s
> [    3.981405] raid6: avx2x1   xor()  8414 MB/s
> [    4.007409] raid6: sse2x4   gen()  9105 MB/s
> [    4.033403] raid6: sse2x4   xor()  5724 MB/s
> [    4.059408] raid6: sse2x2   gen()  7570 MB/s
> [    4.085410] raid6: sse2x2   xor()  4880 MB/s
> [    4.111409] raid6: sse2x1   gen()  6484 MB/s
> [    4.137402] raid6: sse2x1   xor()  4412 MB/s
> 

These are results for this machine:

[   17.707948] raid6: sse2x4   gen() 12196 MB/s
[   17.871946] raid6: sse2x4   xor()  8169 MB/s
[   18.039947] raid6: sse2x2   gen() 10035 MB/s
[   18.195950] raid6: sse2x2   xor()  6954 MB/s
[   18.343951] raid6: sse2x1   gen()  7983 MB/s
[   18.495948] raid6: sse2x1   xor()  6089 MB/s
[   18.577606] raid6: using algorithm sse2x4 gen() 12196 MB/s
[   18.675268] raid6: .... xor() 8169 MB/s, rmw enabled
[   18.774428] raid6: using ssse3x2 recovery algorithm

> For the next step, could you please try the following the beginning of
> --assemble
> run?
> 
>     trace.py -M 10 'r::r5l_recovery_verify_data_checksum()(retval != 0)'
> 
> Thanks,
> Song

Will do and report.

> 
> PS: Some key functions here are inlined and thus not easily traceable. We will
> probably need to patch the kernel for further debugging.
> 

Won't be a problem.
