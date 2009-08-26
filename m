From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 22:34:30 +0200
Message-ID: <873a7exqjt.fsf@frosties.localdomain>
References: <73066.92033.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73066.92033.qm@web51304.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Wed, 26 Aug 2009 04:29:39 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> --- On Wed, 26/8/09, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>
>> From: Goswin von Brederlow <goswin-v-b@web.de>
>> Subject: Re: Raid 5 - not clean and then a failure.
>> To: Jon@eHardcastle.com
>> Cc: linux-raid@vger.kernel.org
>> Date: Wednesday, 26 August, 2009, 12:18 PM
>> Jon Hardcastle <jd_hardcastle@yahoo.com>
>> writes:
>>=20
>> > Guys,
>> >
>> > I have been having some problems with my arrays that I
>> think i have nailed down to a pci controller (well I say
>> that - it is always the drives connected to *a* controller
>> but I have tried 2!) anyway the latest saga is i was trying
>> some new kernel options last night - which didn't work.
>> >
>> > But when i booted up again this morning it said one of
>> the drives was in an inconsistent state (not sure of the
>> *exact* error message). I then kicked off an add of the
>> drive and it started syncing. It got about 5% in and then
>> the second drive in on that controller complained and the
>> array failed.=20
>> >
>> > Is there any hope for my data? If i get a good
>> controller in there will the resync continue? can I try and
>> tell it to assume the drives are good (which they ought to
>> be)?
>> >
>> > Please help!
>>=20
>> The inconsistency is probably just a block here or there
>> and I'm
>> assuming none of your drives actualy failed. So 99.9999% of
>> your data
>> should be there. Just rebooting might actualy just get your
>> raid back
>> (to syncing). If not then you have to force reassembly from
>> the drives
>> with the newest serials. That will give you some data
>> corruption,
>> whatever was writing when the controler gave errors. Worst
>> case you
>> have to recreate the raid with --assume-clean.
>>=20
>> I recommend adding a bitmap to the raid. That way a
>> wrongfully failed
>> drive can be resynced in a matter of minutes instead of
>> hours or
>> days. Makes it way less likely another error occurs during
>> resync.
>>=20
>> MfG
>> =A0 =A0 =A0 =A0 Goswin
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>>=20
>
> I did look into bitmaps *abit* i could easily have the imagine for my=
 6 drive raid 5 stored on the raid1 I have in the same system.. The goo=
gling I did tho did not paint a pretty picture it talked about huge per=
formance hits?

That depends on the bitmap size a lot.

It also depends on the frequency of errors. If your controler has a
hickup once a week causing a drive to fail and you need 1 day to
rebuild the array you will be left with a double disk failure pretty
quickly without bitmaps.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
