From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID-5 degraded mode question
Date: Tue, 22 Dec 2009 14:37:48 +0100
Message-ID: <87aaxbruxf.fsf@frosties.localdomain>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7E75@SDCEXCHANGE01.ad.amcc.com>
	<20091216211237.GA16981@cthulhu.home.robinhill.me.uk>
	<AC5E1C3367E37D44970B81A6ADD1DA2C087E7EA7@SDCEXCHANGE01.ad.amcc.com>
	<87ljgwo5xj.fsf@frosties.localdomain>
	<4877c76c0912212251j22a09138o4cb2f5fe84b9d13b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912212251j22a09138o4cb2f5fe84b9d13b@mail.gmail.com>
	(Michael Evans's message of "Mon, 21 Dec 2009 22:51:54 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Tirumala Reddy Marri <tmarri@amcc.com>, Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> On Mon, Dec 21, 2009 at 4:41 AM, Goswin von Brederlow <goswin-v-b@web=
=2Ede> wrote:
>> "Tirumala Reddy Marri" <tmarri@amcc.com> writes:
>>
>>> Thanks for the response.
>>>
>>>>> =A0Also as soon as disk failed md drivers marks that drive as fau=
lty
>>> and
>>>>> continue operation in degraded mode right ? Is there a way to get=
 out
>>>
>>>>> the degraded mode without adding spare drive. Assuming we have 5 =
disk
>>>
>>>>> system with one failed drive.
>>>>>
>>>>I'm not sure what you want to happen here. =A0The only way to get o=
ut of
>>> degraded mode is to replace the drive in the >array (if it's not
>>> actually faulty then you can add it back, otherwise you need to add=
 a
>>> new drive).
>>>>What were you thinking might happen otherwise?
>>>
>>>
>>> I was thinking we can recover from this using re-sync or resize .Af=
ter
>>
>> Theoretically you could shrink the array by one disk and then use th=
at
>> spare disk to resync the parity. But that is a lengthy process with =
a
>> lot higher failure chance than resyncing to a new disk. Note that yo=
u
>> also need to shrink the filesystem on the raid first adding even mor=
e
>> stress and failure chance. So I really wouldn't recommend that.
>>
>>> running IO to degraded (RAID-5) /dev/md0, I am seeing an issue wher=
e
>>> e2fsck reports inconsistent file system and corrects it. I am tryin=
g to
>>> debug =A0to see if the issue is because of data not being written o=
r
>>> reading wrong data in degraded mode.
>>>
>>> I guess problem happening during the write. Reason is , after ran e=
2fsck
>>> I don't see inconsistency any more.
>>>
>>> Regards,
>>> Marri
>>
>> A degraded raid5 might get corrupted if your system crashes. If you
>> are writing to one of the remaining disks then it also needs to upda=
te
>> the parity block simultaneously. If it crashed between writing the
>> data and the parity then the data block on the failed drive will
>> appear changed. I'm not sure though if the raid will even assemble o=
n
>> its own in such a case though. It might just complain about not havi=
ng
>> enough in-sync disks.
>>
>> Apart from that there should never be any corruption unless one of
>> your disks returns bad data on read.
>>
>> MfG
>> =A0 =A0 =A0 =A0Goswin
>>
>> PS: This is not a bug in linux raid but a fundamental limitation of
>> raid.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> You're forgetting the every horrid possibility of failed/corrupted
> hardware.  I've had IO cards go bad due to a prior bug that let an
> experimental 'debugging' option in the kernel write to random memory
> locations in the rare case of an unusual error.  Not just the
> occasional rare chance of a buffer being corrupted, but the actual
> hardware going bad.  One of the cards could not even be recovered by
> an attempt at software-flashing the firmware (it must have been too
> far gone for the utility to recognize, and replacing it was the least
> expensive route remaining).
>
> However in general I've seen hardware that's actually failing will
> tend to do so with enough grace to either outright refuse to operate,
> or operate with obvious and persistent symptoms.

And how is that relevant to the raid-5 being degraded? If the hardware
goes bad you just get errors no matter what.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
