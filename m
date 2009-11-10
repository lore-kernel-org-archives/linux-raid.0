From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 14:17:58 -0700
Message-ID: <f3177b9e0911101317wcbae93fu71f56fc0142d7f5@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <yq1ljienxql.fsf@sermon.lab.mkp.net>
	 <f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	 <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
	 <87f94c370911101301v4b71ce74hbd4ebd20e7ce2419@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370911101301v4b71ce74hbd4ebd20e7ce2419@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 2:01 PM, Greg Freemyer <greg.freemyer@gmail.com=
> wrote:
> On Tue, Nov 10, 2009 at 3:11 PM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>>>>>> "Chris" =3D=3D Chris Worley <worleys@gmail.com> writes:
>>
> <snip>
>>
>> Chris> And I do appreciate all your work. =A0I fear, in this case, d=
iscard
>> Chris> will be optimized for the slower technology... we won't be
>> Chris> getting all that's available from it.
>>
>> Discard isn't "optimized" for anything. =A0It's a command. =A0Filesy=
stem
>> issues it, it gets sent to the storage device (DSM/TRIM, WRITE SAME,=
 or
>> UNMAP depending on target type).
>>
>
> Martin,
>
> I'm not sure that is right, but Chris is also wrong.

I've not been happier to hear I'm wrong; I do hope you are right
(there will be a switch for optimal approaches).

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
