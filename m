From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: [PATCH] md: Enhancements and clean to linear RAID
Date: Tue, 19 May 2009 18:02:06 +0530
Message-ID: <921ca19c0905190532i264348bas88788a95a1cdbf28@mail.gmail.com>
References: <37d33d830905182323x22eec1c8l2a7471668c1a02b3@mail.gmail.com>
	 <9a138833b29b54e5d6c1eaa188f27399.squirrel@neil.brown.name>
	 <37d33d830905190031u5172af46kccb720343e359d99@mail.gmail.com>
	 <37d33d830905190346g4147a114o5f4a53bf64c1ebac@mail.gmail.com>
	 <18962.39477.173613.395401@notabene.brown>
	 <37d33d830905190456s61cd3168y33a984f4c5c445bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905190456s61cd3168y33a984f4c5c445bf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
Cc: SandeepKsinha <sandeepksinha@gmail.com>
List-Id: linux-raid.ids

Neil,

Is there any git tree where the test cases can be added.
These seem to be huge changes with regard to the dev
interface.

Hopefully the test cases can be added in specific cases.

Thanks,
Sujit

On Tue, May 19, 2009 at 5:26 PM, SandeepKsinha <sandeepksinha@gmail.com=
> wrote:
> Hi Neil,
>
> On Tue, May 19, 2009 at 5:08 PM, Neil Brown <neilb@suse.de> wrote:
>> On Tuesday May 19, sandeepksinha@gmail.com wrote:
>>> Hi Neil,
>>>
>>> I have made all the required changes and have tested the changes.
>>> It works fine.
>>>
>>> Thanks for enlightening me, the changes really optimized the code f=
urther.
>>>
>>> The patches will be followed by this mail.
>>
>> Thanks.
>> I have applied them all (with very minor cleanups) and pushed them t=
o
>> my for-next tree.
>> They can be viewed here:
>> =A0 =A0http://neil.brown.name/git?p=3Dmd;a=3Dshortlog;h=3Drefs/heads=
/for-next
>>
>> I have taken the liberty of rewriting the introductory comments on t=
he
>> patches a little. =A0I hope you don't mind.
>>
>
> Sure. You always have the liberty to do so.
>
>> One important part of the patches that was missing was a
>> "signed-off-by" line.
>> Please read section 12 of Documentation/SubmittingPatches
>> and then if you agree that the you an certify the Developer's
>> Certificate of Origin on these patches, please write explicitly that=
 I
>> should add your Signed-off-by line to these patches.
>>
>
> Yes, So, I kindly request you to add
> "Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>"
> against each of the patches.
>
> Thanks a lot.
>
>> I have no doubt that the patches are suitably original, but the
>> process requires that you explicitly tell me so.
>>
>> Thanks,
>> NeilBrown
>>
>
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
-- Sujit K M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
