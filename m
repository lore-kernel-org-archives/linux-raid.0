From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Mon, 26 Apr 2010 12:58:09 -0700
Message-ID: <u2r4877c76c1004261258t317657f7radd2d52f2fac3cdf@mail.gmail.com>
References: <m2h4877c76c1004261144h1019e9afkf05396996ea77a99@mail.gmail.com>
	<406003.10607.qm@web65416.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <406003.10607.qm@web65416.mail.ac4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Klaassen <clawsoon@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 26, 2010 at 11:57 AM, Andrew Klaassen <clawsoon@yahoo.com> =
wrote:
> --- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com> wrote:
>
>> > --- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com>
>> wrote:
>> > However, it doesn't say what happens with a larger
>> > number of drives. =A0I'm looking for the kind of control I
>> > can get with RAID 1+0, where I can specify which drives are
>> > mirrors of each other. =A0Is that possible with RAID10?
>>
>> No, not predictably; the only provided guarantee is that
>> the data will
>> /not/ be duplicated on the same block-device (usually
>> drive).=A0 In
>> practice you will quickly be able to determine where a
>> particular
>> version with a given range of input causes data to be
>> stored, but
>> there is no requirement that future versions produce the
>> precise same
>> alignment and offsets.
>
> Ah. =A0So if I want this level of control, I have to sacrifice the ad=
vantages of RAID 10 and go with RAID 1+0.
>
> Good to know. =A0Thanks.
>
> Andrew
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Or write your own program to generate mdadm headers on uninitialized
devices.  Or if it's just a one time thing, write the headers, stop
the array, make sure it says what you want, and then force a resync
before writing any data.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
