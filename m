From: Eric Shubert <ejs@shubes.net>
Subject: Re: RAID Class Drives`
Date: Mon, 22 Mar 2010 09:29:12 -0700
Message-ID: <ho85sp$jug$1@dough.gmane.org>
References: <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com> <38.31.05956.E4417AB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38.31.05956.E4417AB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Aryeh Gregor
>> Sent: Friday, March 19, 2010 11:43 AM
>> To: John Robinson
>> Cc: Joachim Otahal; linux-raid@vger.kernel.org
>> Subject: Re: RAID Class Drives`
>>
>> On Fri, Mar 19, 2010 at 4:15 AM, John Robinson
>> <john.robinson@anonymous.org.uk> wrote:
>>> Do you have a reference for this? Most drives' operating temperatur=
e
>> range
>>> is specified up to 55=B0C, sometimes higher for enterprise drives, =
without
>> any
>>> indication (apart from common sense perhaps) that running them this=
 hot
>>> reduces lifespan.
>> Google's study of >100,000 disks over 9 months or so
>> <http://labs.google.com/papers/disk_failures.html> suggests that
>> hotter drives don't fail much more often:
>>
>> ". . . failures do not increase when the average temperature
>> increases. In fact, there is a clear trend showing that lower
>> temperatures are associated with higher failure rates.  Only at very
>> high temperatures is there a slight reversal of this trend." (page 5
>> of PDF)
>>
>> "We can conclude that at moderate temperature ranges it is likely th=
at
>> there are other effects which affect failure rates much more strongl=
y
>> than temperatures do." (page 6)
>>
>> They were using SATA and PATA consumer drives, 5400 RPM to 7200 RPM,
>> 80 to 400 GB, put into production in or after 2001 (from page 3).
>=20
> 	First of all, not what they call "high" temperatures in the paper
> are not really very high.  Eighty C is roughly the boiling point of E=
thyl
> Alcohol, and in human terms this is considered quite hot.  Immersion =
of body
> tissues in a large volume of 80C water for several seconds will resul=
t in
> moderately severe burns.  For most mechanical systems however, 80C is=
 not
> particularly hot.  Many solid state electronics systems can withstand=
 80C
> internal temperatures indefinitely.  An average healthy adult human b=
eing
> has a body core temperature of 37C, and a device with a 40C surface
> temperature is barely warm to the touch.  It is not hot. Unless one e=
mploys
> a refrigerated fluid cooling system or a Peltier junction to actively=
 cool
> it, no drive system is ever going to be less than 30C if the room
> temperature is anything other than uncomfortably cold.  It's rather c=
old in
> my house right now, because I have the heat shut off to save money, y=
et the
> coolest drive in my arrays - which have very effective forced air sys=
tems
> built in to them - are 31C.  Most are over 33C by a wide margin.  Com=
e
> summer, all of them will be over 40C.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

I had a few drives running at about 55C for a couple years, with no=20
failures (knock wood). These were used drives before being put into tha=
t=20
environment, so they arguably had already survived the "infant mortalit=
y=20
syndrome" that the google study identified. Would I recommend running=20
drives at 55C? No, but I wouldn't be too concerned about it either.

=46WIW.

--=20
-Eric 'shubes'

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
