From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 10:44:15 +0200
Message-ID: <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
References: <20170423154240.GA3494@metamorpher.de> <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com> <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de> <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de> <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de> <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170425001614.GA3936@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-25 2:16 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Tue, Apr 25, 2017 at 01:00:47AM +0200, Patrik Dahlstr=C3=B6m wrote:
>> 6 disk raid xor check: 84 ^ f6 ^ 87 ^ 96 ^ e1 ^ 82 =3D=3D 0, OK
>
> This should be the 6 disk raid area.
Agreed
>
>> 5 disk raid xor check: 46 ^ 73 ^ 6d ^ 06 ^ 5e =3D=3D 0, OK
>
> This should be the 5 disk raid area.
Agreed
>
>> 6 disk raid xor check: 46 ^ 73 ^ 6d ^ 06 ^ 5e ^ 00 =3D=3D 0, OK
>
> Still 5 disks... grow did not progess until here,
> and the 6th disk is likely zero because it's new.
Agreed
>
>> But immediately before that, I can't get the xor sums to line up:
>> 0xfaa287ffff: b0 ^ 6d ^ 13 ^ 1b ^ b7 !=3D ae (62 actually), NOK
>> This would mean that it's incorrect for both 5 and 6 disk raids.
>
> Not too sure about this point.
>
> If it up and died in mid-grow there might be a chunk that's wrong.
>
> But that's a few kilobytes, not...
>
>> That is a span of ~52 GB where I presumably can't get the checksums
>> right. What does all this mean? What am I missing?
>
> ...well, it would make sense if a disk got kicked / went missing
> and it progressed the reshape for another ~52GB afterwards.
Would that mean that I should be able to get the checksum to match if
I remove one of the values in a mismatching series. I have tried this,
but never got it correct.

> And you're hoping the VALID DATA areas will overlap. They would if it
> progressed far enough with all disks and not too far with one missing.
How do I test this? I haven't really used overlays before.

> Or you just have to identify the questionable drive and kick it out.
I'm still not sure if a drive was actually kicked out of the array. I
don't have any memory of discovering that a drive was suddenly kicked
out. Would a kicked out drive be automatically re-added if it came
back?
Shouldn't I find something about it in my syslog or kernel log?
I checked my command history and I didn't find any --fail commands
(except on /dev/mapper/sdf)
Should I post the command history here? It is quite long and doesn't
contain return codes or command output.

>
> You have some experimenteering to do :-|
>
> (
>     Not sure if I'm still making sense at this point. Sorry.
> )
>
> Regards
> Andreas Klauer
>
