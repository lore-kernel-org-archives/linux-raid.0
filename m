From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Write intent bitmaps.
Date: Wed, 2 Sep 2009 13:36:13 -0400
Message-ID: <7d86ddb90909021036j744df1d0s151ddb3712f6b4f7@mail.gmail.com>
References: <5c45fce80908230116o2f129ab4y8d255cbe83bfac5b@mail.gmail.com>
	 <87ws4t4bjz.fsf@frosties.localdomain>
	 <ABFC24E4C13D81489F7F624E14891C860D1F15EF@uk-ex-mbx1.terastack.bluearc.com>
	 <09198ab3b722ad5aa40d32f78626953e.squirrel@neil.brown.name>
	 <4A9E9902.8050408@tmr.com> <4A9E9D1B.4080209@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A9E9D1B.4080209@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Bill Davidsen <davidsen@tmr.com>, NeilBrown <neilb@suse.de>, Simon Jackson <sjackson@bluearc.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You could just provide more information in the mdadm bitmap error messa=
ge

mdadm: unknown bitmap version 0, either the bitmap file is corrupted
or you need to upgrade your tools

suggested change

mdadm: unknown bitmap version 0, either the bitmap file is corrupted,
you are looking looking at the array and not an array component, or
you need to upgrade your tools

Ryan

On Wed, Sep 2, 2009 at 12:28 PM, Paul
Clements<paul.clements@steeleye.com> wrote:
> Bill Davidsen wrote:
>>
>> NeilBrown wrote:
>>>
>>> On Tue, August 25, 2009 12:39 am, Simon Jackson wrote:
>>>
>>>>
>>>> I am trying to use write intent bitmaps on some RAID 1 volumes to =
reduce
>>>> the rebuild times in the event of hard resets that cause the md dr=
iver
>>>> to
>>>> kick members out of my arrays.
>>>>
>>>> I used the mdadm --grow /dev/md0 --bitmap=3Dinternal =A0and this a=
ppeared to
>>>> succeed, but when I tried to examine the bitmap I get an error.
>>>>
>>>>
>>>> :~$ sudo mdadm --grow /dev/md0 --bitmap=3Dinternal
>>>> :~$ sudo mdadm -X /dev/md0
>>>> =A0 =A0 =A0 =A0Filename : /dev/md0
>>>> =A0 =A0 =A0 =A0 =A0 Magic : 00000000
>>>> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be cor=
rupted
>>>> =A0 =A0 =A0 =A0 Version : 0
>>>> mdadm: unknown bitmap version 0, either the bitmap file is corrupt=
ed or
>>>> you need to upgrade your tools
>>>>
>>>
>>> Quoting from the man page:
>>>
>>> =A0 =A0 =A0 -X, --examine-bitmap
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0Report =A0information about a bitmap fil=
e. =A0The argument is
>>> either
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0an external bitmap file or an array =A0c=
omponent =A0in =A0case =A0of
>>> =A0an
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0internal =A0bitmap. =A0 Note =A0that =A0=
running =A0this on an array
>>> device
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0(e.g. =A0/dev/md0) does not report the b=
itmap for that array.
>>>
>>>
>>> Particularly read the last sentence.
>>> Then try
>>> =A0 mdadm -X /dev/sda5
>>>
>>
>> Well that's nice and clear, but raises the question "why not?" This =
would
>> seem to be one of the most common things someone would do, to look a=
t the
>> bitmap for an array.
>
> Two reasons why not:
>
> The examine code simply takes the device or file you give it and look=
s for a
> bitmap in that file or device. You'd have to do some hand-waving to "=
read
> the bitmap for /dev/md0". There actually is no bitmap on /dev/md0; th=
ere is
> a bitmap stored either in a file or on each of the component devices.=
 So
> which version of the bitmap do you read? From the first, second, thir=
d ...
> component disk?
>
> Also, mdadm's behavior would be ambiguous if you implemented the abov=
e. What
> if /dev/md0 is itself a component of another md device? Then how is m=
dadm to
> know which bitmap you want? The one that actually physically exists o=
n md0,
> or the ones that the components of md0 contain?
>
> Perhaps better would be to simply throw an error in this case?
>
> --
> Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
