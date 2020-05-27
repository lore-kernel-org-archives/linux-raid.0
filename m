From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Wed, 27 May 2020 15:36:06 +0200
Message-ID: <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/27/20 1:37 AM, Song Liu wrote:
> On Mon, May 25, 2020 at 9:23 AM Michal Soltys <msoltyspl@yandex.pl> wrote:
>>
>> On 5/19/20 1:55 AM, Song Liu wrote:
>>>
>>> 2. try use bcc/bpftrace to trace r5l_recovery_read_page(),
>>> specifically, the 4th argument.
>>> With bcc, it is something like:
>>>
>>>       trace.py -M 100 'r5l_recovery_read_page() "%llx", arg4'
>>>
>>> -M above limits the number of outputs to 100 lines. We may need to
>>> increase the limit or
>>> remove the constraint. If the system doesn't have bcc/bpftrace. You
>>> can also try with
>>> kprobe.
>>>
>>
>>
> 
> Looks like the kernel has processed about 1.2GB of journal (9b69bb8 -
> 98f65b8 sectors).
> And the limit is min(1/4 disk size, 10GB).
> 
> I just checked the code, it should stop once it hits checksum
> mismatch. Does it keep going
> after half hour or so?

It keeps going so far (mdadm started few hours ago):

xs22:/home/msl☠ head -n 4 trace.out
TIME     PID     TID     COMM            FUNC             -
12:58:21 40739   40739   mdadm           r5l_recovery_read_page 98f65b8
12:58:21 40739   40739   mdadm           r5l_recovery_read_page 98f65c0
12:58:21 40739   40739   mdadm           r5l_recovery_read_page 98f65c8
xs22:/home/msl☠ tail -n 4 trace.out
15:34:50 40739   40739   mdadm           r5l_recovery_read_page bc04e88
15:34:50 40739   40739   mdadm           r5l_recovery_read_page bc04e90
15:34:50 40739   40739   mdadm           r5l_recovery_read_page bc04e98
