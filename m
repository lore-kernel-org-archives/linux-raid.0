From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why does one get mismatches?
Date: Sat, 30 Jan 2010 00:52:28 +0100
Message-ID: <87fx5owjsz.fsf@frosties.localdomain>
References: <166572.83607.qm@web51301.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <166572.83607.qm@web51301.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Fri, 29 Jan 2010 07:37:05 -0800 (PST)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> --- On Thu, 28/1/10, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>
>> From: Goswin von Brederlow <goswin-v-b@web.de>
>> Subject: Re: Why does one get mismatches?
>> To: linux-raid@vger.kernel.org
>> Date: Thursday, 28 January, 2010, 20:24
>> "Tirumala Reddy Marri" <tmarri@amcc.com>
>> writes:
>>=20
>> > I just tried and miss-match count is zero.
>> Interesting, is XOR engine
>> > doing something wrong ? . Then I ran a test where I
>> raw-write the file
>> > to /dev/md0. Then did the raw-read for the same size.
>> In this case XOR
>> > matched as expected. Then I failed a drive using
>> "mdadm -f /dev/md0
>> > /dev/sda". Then I read the same size data again from
>> /dev/md0. And
>> > checksum matches too.=20
>> > What is this mean XOR engine is doing right thing. But
>> "chec/repair"
>> > test is not functioning properly with XOR-engine ?
>> >
>> > Or is this something to do with=A0 how the buffers
>> are handled ? may they
>> > are cached ?
>> >
>> >
>> > -Marri
>>=20
>> No idea. But if everything works without the XOR engine and
>> gives
>> mismatches with then I would think there is a software or
>> hardware error
>> there and not in the cable or disks.
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
> i think my RAM is fecked - does that sound like a possible cause? mem=
test86 gives PAGES of red errors when run but the POST gives nothing an=
d the machine boots.... it has 512MB
>
> i have some more on order as a speculative..=20

If memtest gives errors you certainly have errors. The reverse isn't
allways true.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
