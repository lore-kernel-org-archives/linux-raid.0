From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Why does one get mismatches?
Date: Tue, 2 Mar 2010 04:13:54 -0800
Message-ID: <4877c76c1003020413s6560cda8o49311d2a70b1af89@mail.gmail.com>
References: <4B7B0D45.7040801@tmr.com> <20100218100547.7aecdc34@notabene.brown>
	 <4B853BBF.7000607@tmr.com> <yq1ocjemx46.fsf@sermon.lab.mkp.net>
	 <20100225083936.07cd48ad@notabene.brown>
	 <20100228080949.GA30574@maude.comedia.it>
	 <20100302160100.621f9811@notabene.brown>
	 <20100302073624.GA28827@maude.comedia.it>
	 <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
	 <20100302110232.GA14131@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100302110232.GA14131@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 2, 2010 at 3:02 AM, Luca Berra <bluca@comedia.it> wrote:
> On Tue, Mar 02, 2010 at 02:04:47AM -0800, Michael Evans wrote:
>>
>> On Mon, Mar 1, 2010 at 11:36 PM, Luca Berra <bluca@comedia.it> wrote=
:
>>>
>>> On Tue, Mar 02, 2010 at 04:01:00PM +1100, Neil Brown wrote:
>>>>>
>>>>> Disk 1 contains A and B in the correct order, it is missing C and=
 B'
>>>>> but
>>>>> we
>>>>> dont care, app should be able to recover from a crash
>>>>>
>>>>> Disk 2 contains A and B', but they are wrongly ordered because C =
is
>>>>> missing
>>>>>
>>>>> If in the above case A and C are data blocks and B contains a jou=
rnal
>>>>> related to A and C, booting from disk 2 could result in inconsist=
ent
>>>>> data.
>>>>>
>>>>> can the above really happen?
>>>>> would using barriers remove the above concern?
>>>>> am i missing something else?
>>>>
>>>> These is no inconsistency here that a filesystem would not equally
>>>> expect
>>>> from a single device.
>>>> After the crash-while-writing B', it should expect to see either B=
 or
>>>> B',
>>>> and it does, depending on which device is primary.
>>>>
>>>> Nothing to see here.
>>>
>>> I will try to explain better,
>>> the problem is not related to the confusion between B or B'
>>>
>>> the problem is that on one disk we have B' _without_ C.
>>>
>> You're demanding full atomic commits; this is precisely what journal=
s
>> and /barriers/ are for.
>>
>> Are you are bypassing them in a quest for performance and paying for
>> it on crashes?
>> Or is this a hardware bug?
>> Or is it some glitch in the block device layering leading to barrier
>> requests not being honored?
>
> I just asked for confirmation that with /barriers/ the scenario above
> would not happen.
>
> L.
>
> --
> Luca Berra -- bluca@comedia.it
> =A0 =A0 =A0 =A0Communication Media & Services S.r.l.
> =A0/"\
> =A0\ / =A0 =A0 ASCII RIBBON CAMPAIGN
> =A0X =A0 =A0 =A0 =A0AGAINST HTML MAIL
> =A0/ \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Yes, obviously atomic commits require barriers.  Older hardware and
operating systems that didn't allow any form of buffering or out of
order operations (hardware can re-arrange commits internally now)
inherently had a barrier between every operation.  Modern devices and
systems have so many layers of interacting buffers with operation
re-ordering to optimize throughput that such predictability is lacking
unless explicitly requested via the form of a barrier.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
