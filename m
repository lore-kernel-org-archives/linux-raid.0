From: Beolach <beolach@gmail.com>
Subject: Re: Special drives for Linux Raid?
Date: Mon, 7 Nov 2011 11:00:55 -0700
Message-ID: <CADc_k_se=GzaYfiWv0p49YP+xBfgBL7_JLCYYa8C0Dcm0T1XAA@mail.gmail.com>
References: <4EB7DD23.9090907@agenda.si> <4EB7E1F8.7060803@meetinghouse.net> <j98s0f$a0f$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j98s0f$a0f$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 7, 2011 at 07:57, David Brown <david@westcontrol.com> wrote=
:
> On 07/11/2011 14:49, Miles Fidelman wrote:
>>
>> Danilo Godec wrote:
>>>
>>> Some manufacturers make 'special' versions of drives for RAID (WD R=
E4,
>>> Seagate SE, ...). Apparently the main difference is in error handli=
ng,
>>> where normal 'desktop' drives try hard to recover an error (up to
>>> several minutes) while RAID drives give up quickly (few seconds) so
>>> that the RAID controller can take over.
>>>
>> not so much "special" as "different"
>>
>> the term to look for is "enterprise"
>>
>> you've identified the key distinction:
>>
>> - desktop drives assume that they have the only copy of your data, t=
he
>> on-board processor tries very hard to read and re-read until it retu=
rns
>> your data ---- the result is that everything slows down
>>
>> - if you have a raid array, you want a failing disk to give up and
>> return, very quickly, so that the data can be read from a different =
drive
>>
>> I learned this the hard way, when I had a server that just slowed wa=
y
>> down to the point that it took 10 seconds or more to echo a keystrok=
e.
>> It took me a long time to figure out what was going on - and some ra=
ther
>> painful false starts (trashed the o/s).
>>
>> One important thing I discovered: the md RAID driver does NOT consid=
er a
>> long time delay as a signal to fail a drive out of an array. It's a
>> really good idea to run mdstat and keep an eye on your drives. If Ra=
w
>> Reed Error goes above 0, start paying attention.
>>
>
> As far as I know (and I hope I'll be corrected quickly if I'm wrong),=
 when a
> drive fails to read from a sector, it will be considered a "failed" d=
rive by
> the raid controller or software raid, and kicked out of the array. =C2=
=A0The
> exception is the latest versions of md raid which support bad block l=
ists.
>

I don't think that's quite correct - when a member drive of an MD RAID
returns a read error, MD tries to re-write the sector using the
redundancy from the other drives in the RAID.  It's only if a drive
returns a *write* error that the drive is failed.


--=20
Conway S. Smith
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
