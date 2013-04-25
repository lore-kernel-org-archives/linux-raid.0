From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Thu, 25 Apr 2013 13:11:42 +0300
Message-ID: <d18a214b4409b4787adebff432d76b59@redhost.ro>
References: <5171CBF9.9020701@redhost.ro>
 <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro>
 <51747382.1010105@hardwarefreak.com>
 <5a749bb56c88b6d6b8a806694b163bda@redhost.ro>
 <5175F71A.8030805@hardwarefreak.com> <51765FD7.8090309@redhost.ro>
 <51775078.3000500@hardwarefreak.com> <51779720.6040109@redhost.ro>
 <51780A3F.80104@hardwarefreak.com> <517852D2.2050109@redhost.ro>
 <CAH3kUhHnF0imY=CAHfzaQy4XJuOMgOtbHNp17EYzeSJR2en7Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHnF0imY=CAHfzaQy4XJuOMgOtbHNp17EYzeSJR2en7Fg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I don't have fstab discard option set. I was just enumerating the trim=20
kinds I know. I did try discard but it didn't do anything good. And the=
=20
problem dated from before my discard test.

Regards!

On 2013-04-25 00:53, Roberto Spadim wrote:
> TRIM in ext4 =3D discard
> 2013/4/24 Andrei Banu <andrei.banu@redhost.ro>
>=20
>> Hi,
>> 1. How can I at least start trying to find the daemon that might be=20
>> doing this?
>> 2. I am not sure what real time TRIM is. I thought there was the=20
>> 'discard' option in
>> fstab (which I tried and didn't help) and other command like trims=20
>> (fstrim - which
>> errors out when run on / or mdtrim that seems somebody's experiment)=
=2E=20
>> But I
>> am not sure what real time trim might be.
>> I am not really sure where do I go from here. I am a bit lost as it=20
>> seems we hit
>> a dead end.
>> Thanks!
>> Andrei Banu
>> On 24/04/2013 7:37 PM, Stan Hoeppner wrote:
>>=20
>>> On 4/24/2013 3:26 AM, Andrei Banu wrote:
>>>=20
>>>> Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
>>>> =C2=A0 =C2=A0TID =C2=A0PRIO =C2=A0USER =C2=A0 =C2=A0 DISK READ =C2=
=A0DISK WRITE =C2=A0SWAPIN =C2=A0 =C2=A0 IO>=20
>>>> COMMAND
>>>> =C2=A0 =C2=A0541 be/3 root =C2=A0 =C2=A0 =C2=A0 =C2=A00.00 B/s =C2=
=A0 =C2=A00.00 B/s =C2=A00.00 % 96.96 %=20
>>>> [jbd2/md2-8]
>>> This seems to be your problem. =C2=A0jbd2 (journal block device) is=
=20
>>> causing
>>> 97% iowait, yet without doing much physical IO. =C2=A0This is a com=
ponent=20
>>> of
>>> EXT4. =C2=A0As this will fire intermittently it explains why you se=
e such=20
>>> a
>>> wide throughput gap between tests at different points in time.
>>> This isn't a bug or Google would reveal that. =C2=A0Andrei, you nee=
d to
>>> identify which daemon or kernel feature is causing this. =C2=A0Do y=
ou=20
>>> happen
>>> to have realtime TRIM enabled? =C2=A0It is well known to bring IO t=
o a=20
>>> crawl.
>>> If not realtime TRIM, I'd guess you turned a knob you should not=20
>>> have in
>>> some config file, causing a daemon to frequently issue a few=20
>>> gazillion
>>> atomic updates.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
"=20
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml=20
>> [1]
> --
> Roberto Spadim
> Links:
> ------
> [1] http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
