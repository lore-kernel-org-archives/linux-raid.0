From: Luca Berra <bluca@comedia.it>
Subject: Re: Why does one get mismatches?
Date: Tue, 2 Mar 2010 12:02:32 +0100
Message-ID: <20100302110232.GA14131@maude.comedia.it>
References: <4B7B0D45.7040801@tmr.com> <6db64f7872286165ac1fd3436e9d6476@localhost> <20100218100547.7aecdc34@notabene.brown> <4B853BBF.7000607@tmr.com> <yq1ocjemx46.fsf@sermon.lab.mkp.net> <20100225083936.07cd48ad@notabene.brown> <20100228080949.GA30574@maude.comedia.it> <20100302160100.621f9811@notabene.brown> <20100302073624.GA28827@maude.comedia.it> <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 02, 2010 at 02:04:47AM -0800, Michael Evans wrote:
>On Mon, Mar 1, 2010 at 11:36 PM, Luca Berra <bluca@comedia.it> wrote:
>> On Tue, Mar 02, 2010 at 04:01:00PM +1100, Neil Brown wrote:
>>>> Disk 1 contains A and B in the correct order, it is missing C and B' but
>>>> we
>>>> dont care, app should be able to recover from a crash
>>>>
>>>> Disk 2 contains A and B', but they are wrongly ordered because C is
>>>> missing
>>>>
>>>> If in the above case A and C are data blocks and B contains a journal
>>>> related to A and C, booting from disk 2 could result in inconsistent
>>>> data.
>>>>
>>>> can the above really happen?
>>>> would using barriers remove the above concern?
>>>> am i missing something else?
>>>
>>> These is no inconsistency here that a filesystem would not equally expect
>>> from a single device.
>>> After the crash-while-writing B', it should expect to see either B or B',
>>> and it does, depending on which device is primary.
>>>
>>> Nothing to see here.
>>
>> I will try to explain better,
>> the problem is not related to the confusion between B or B'
>>
>> the problem is that on one disk we have B' _without_ C.
>>
>You're demanding full atomic commits; this is precisely what journals
>and /barriers/ are for.
>
>Are you are bypassing them in a quest for performance and paying for
>it on crashes?
>Or is this a hardware bug?
>Or is it some glitch in the block device layering leading to barrier
>requests not being honored?
I just asked for confirmation that with /barriers/ the scenario above
would not happen.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
