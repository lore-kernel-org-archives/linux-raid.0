From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Why does one get mismatches?
Date: Tue, 2 Mar 2010 02:04:47 -0800
Message-ID: <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
References: <20100211161444.7a0ea7bb@notabene.brown> <4B7B0D45.7040801@tmr.com>
	 <6db64f7872286165ac1fd3436e9d6476@localhost>
	 <20100218100547.7aecdc34@notabene.brown> <4B853BBF.7000607@tmr.com>
	 <yq1ocjemx46.fsf@sermon.lab.mkp.net>
	 <20100225083936.07cd48ad@notabene.brown>
	 <20100228080949.GA30574@maude.comedia.it>
	 <20100302160100.621f9811@notabene.brown>
	 <20100302073624.GA28827@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100302073624.GA28827@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 1, 2010 at 11:36 PM, Luca Berra <bluca@comedia.it> wrote:
> On Tue, Mar 02, 2010 at 04:01:00PM +1100, Neil Brown wrote:
>>
>> On Sun, 28 Feb 2010 09:09:49 +0100
>> Luca Berra <bluca@comedia.it> wrote:
>>
>>> On Thu, Feb 25, 2010 at 08:39:36AM +1100, Neil Brown wrote:
>>> >On Wed, 24 Feb 2010 11:12:09 -0500
>>> >"Martin K. Petersen" <martin.petersen@oracle.com> wrote:
>>> >
>>> >> So realistically both disk blocks are wrong and there's a window=
 until
>>> >> the new, correct block is written. =A0That window will only caus=
e
>>> >> problems
>>> >> if there is a crash and we'll need to recover. =A0My main concer=
n here
>>> >> is
>>> >> how big the discrepancy between the disks can get, and whether w=
e'll
>>> >> end
>>> >> up corrupting the filesystem during recovery because we could
>>> >> potentially be matching metadata from one disk with journal entr=
ies
>>> >> from
>>> >> another.
>>> >
>>> >After a crash, md will only read from one of the devices (the firs=
t)
>>> > until a
>>> >resync has completed. =A0So there should be no room for more confu=
sion
>>> > than you
>>> >would expect on a single device.
>>>
>>> After thinking more about this i could come up with another concern
>>> about write ordering.
>>>
>>> example
>>> app writes block A, B, C
>>> md writes A on both disks
>>> md writes B on disk1
>>> app writes B again (B')
>>> md writes B' on disk2
>>> now md would write B' again on both disks, but the system crashes
>>> (note, C is never written due to crash)
>>>
>>> Disk 1 contains A and B in the correct order, it is missing C and B=
' but
>>> we
>>> dont care, app should be able to recover from a crash
>>>
>>> Disk 2 contains A and B', but they are wrongly ordered because C is
>>> missing
>>>
>>> If in the above case A and C are data blocks and B contains a journ=
al
>>> related to A and C, booting from disk 2 could result in inconsisten=
t
>>> data.
>>>
>>> can the above really happen?
>>> would using barriers remove the above concern?
>>> am i missing something else?
>>
>> These is no inconsistency here that a filesystem would not equally e=
xpect
>> from a single device.
>> After the crash-while-writing B', it should expect to see either B o=
r B',
>> and it does, depending on which device is primary.
>>
>> Nothing to see here.
>
> I will try to explain better,
> the problem is not related to the confusion between B or B'
>
> the problem is that on one disk we have B' _without_ C.
>
> Regards,
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

You're demanding full atomic commits; this is precisely what journals
and /barriers/ are for.

Are you are bypassing them in a quest for performance and paying for
it on crashes?
Or is this a hardware bug?
Or is it some glitch in the block device layering leading to barrier
requests not being honored?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
