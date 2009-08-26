From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 10:14:31 -0400
Message-ID: <7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com>
References: <15771.7292.qm@web51312.mail.re2.yahoo.com>
	 <87hbvu9626.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hbvu9626.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wouldn't weekly RAID consistency checks reveal a bad block before you
had a failure that required the need to do a full resync? It only
takes 3 hours to resync my 3 x 1TB drives and having a bitmap would
reduce the performance. I've never had to have a resync in the year
I've had the array up. I just wonder if the performance drawback is
worth having the bitmap to save a possible resync once every couple
years. Or are the RAID consistency checks not reliable enough to
prevent more errors during a resync?

Ryan

On Wed, Aug 26, 2009 at 7:18 AM, Goswin von Brederlow<goswin-v-b@web.de=
> wrote:
> Jon Hardcastle <jd_hardcastle@yahoo.com> writes:
>
>> Guys,
>>
>> I have been having some problems with my arrays that I think i have =
nailed down to a pci controller (well I say that - it is always the dri=
ves connected to *a* controller but I have tried 2!) anyway the latest =
saga is i was trying some new kernel options last night - which didn't =
work.
>>
>> But when i booted up again this morning it said one of the drives wa=
s in an inconsistent state (not sure of the *exact* error message). I t=
hen kicked off an add of the drive and it started syncing. It got about=
 5% in and then the second drive in on that controller complained and t=
he array failed.
>>
>> Is there any hope for my data? If i get a good controller in there w=
ill the resync continue? can I try and tell it to assume the drives are=
 good (which they ought to be)?
>>
>> Please help!
>
> The inconsistency is probably just a block here or there and I'm
> assuming none of your drives actualy failed. So 99.9999% of your data
> should be there. Just rebooting might actualy just get your raid back
> (to syncing). If not then you have to force reassembly from the drive=
s
> with the newest serials. That will give you some data corruption,
> whatever was writing when the controler gave errors. Worst case you
> have to recreate the raid with --assume-clean.
>
> I recommend adding a bitmap to the raid. That way a wrongfully failed
> drive can be resynced in a matter of minutes instead of hours or
> days. Makes it way less likely another error occurs during resync.
>
> MfG
> =A0 =A0 =A0 =A0Goswin
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
