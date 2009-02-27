From: "NeilBrown" <neilb@suse.de>
Subject: Re: can metadata type be changed for an active array?
Date: Fri, 27 Feb 2009 16:24:25 +1100 (EST)
Message-ID: <ca0a760919ed20431e24003d08b30998.squirrel@neil.brown.name>
References: <dbd51810902261112h26ca8429l835272401f555c54@mail.gmail.com>
    <983bc6fdcd28a2885e2c5933dafc72eb.squirrel@neil.brown.name>
    <dbd51810902262110t5c5a996ew42662c9b399812ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dbd51810902262110t5c5a996ew42662c9b399812ab@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: PGNet <pgnet.trash+raid@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, February 27, 2009 4:10 pm, PGNet wrote:
> hi,
>
> On Thu, Feb 26, 2009 at 8:57 PM, NeilBrown <neilb@suse.de> wrote:
>> However the 1.0 metadata uses less space than the 0.90 metadata so
>> it is fairly safe to simply stop the array and then create it with 1=
=2E0
>> metadata. =A0All your data will still be there.
>
> curious, is that also true for 1.0 -> 1.2 ?

No.
The difference between 1.0, 1.1, and 1.2 is where the metadata lives.
1.0 uses a similar location to 0.90.
1.1 and 1.2 use locations near the start of the device.


>
>> The bitmap could get written at a different place, and could over-wr=
ite
>> data. =A0So to be safe:
>
> got it.
>
>>  mdadm --assemble /dev/md5 --metadata=3D1.0 --update=3Dmetadata
>> /dev/sd[ab]2
>
> fair enough.
>
> thanks!
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
