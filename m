From: Sam Bingner <sam@bingner.com>
Subject: Re: Raid recovery. Help wanted!
Date: Sun, 21 Apr 2013 23:37:53 +0000
Message-ID: <190A45D8-1F37-460D-A44A-9E48F2EF7700@bingner.com>
References: <517410F6.8050605@maris.no>
 <CADNH=7Fv7NzE85P0ABorzWhsTEBKzd2Fnm27UxhsnmvVArqShg@mail.gmail.com>,<51742182.5040702@maris.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51742182.5040702@maris.no>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Evgeny Koryanov <evgeny.koryanov@maris.no>
Cc: =?iso-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Apr 21, 2013, at 7:27 AM, "Evgeny Koryanov" <evgeny.koryanov@maris.n=
o> wrote:

>=20
> On 21.04.2013 20:40, Mathias Bur=E9n wrote:
>> On 21 April 2013 17:16, Evgeny Koryanov <evgeny.koryanov@maris.no> w=
rote:
>>> Hello everybody!
>>>=20
>>> Yesterday I met a problem with one of raid5 arrays build by mdadm o=
n three
>>> (sd[bcd]) 1.5T devices.
>>> I found array in degraded state with sdd fail. Drive becomes fail s=
tate
>>> after power jump.
>>> Server supplied by UPS but this seems was not good enough - server =
was not
>>> rebooted but one drive as I said becomes fail state.
>>> I simply reattaches it and array started rebuilding but fails after=
 couple
>>> of %'s passed with sdc becomes fail!!!
>>> I assemble array again with sd[bc] and tried to attach sdd again: p=
icture
>>> repeated rebuild fails.
>>> So I have sdb in sync state, sdc - failed and sdd spare. I checked =
SMARTs of
>>> drives to understand reason of such behavior and
>>> found it clean on all devices. Than I tried to dd if=3D/dev/sd[bcd]
>>> of=3D/dev/null and found that dd also fails with IO error.
>>> After dd bad blocks started appears in SMART :)
>>> Finally I have:
>>> sdb - sync
>>> sdc - fail
>>> sdd - spare
>>> states and a number of bads on each hdd in random places...
>>>=20
>>> Could any one suggest how can I assemble this array now in read-onl=
y mode to
>>> try to copy data?!
>>> Theoretically data on sdd should not be rewritten and it still shou=
ld be
>>> possible to try recover data (meaning that bads appears in quite di=
fferent
>>> places)...
>>> May be you know utility which helps recover data or the way how to =
start
>>> array in read-only mode preventing becomes it to degraded state
>>> and force md device to try recover data using readable places from =
each
>>> devise???
>>> Or any other ideas appreciated! Thanks, any way...
>>>=20
>>> Best regards,
>>>                 Evgeny.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Hi,
>>=20
>> Could you post the smartctl -a output of all the drives? If 2 drives
>> are failling you might want to derescue them somewhere and assemble
>> the RAID from that.
>>=20
>> Mathias
> Hi, Mathis.
>=20
> Will post it tomorrow - it's down now and I'm not around.
> But as per your suggestion: still not clear for me is it good idea - =
as soon as I will copy valid data to another drive
> information about bad's places will be lost (for md device driver) an=
d bad blocks physically will be replaced by zeros.
> And what will happen after assembling and trying to read places where=
 bad blocks was (where array marked sync and blocks are
> not consistent - redundant part zeroed) - will md read properly? will=
 md mark drive fail as soon as find async (zeroed) block ans start resy=
nc... Actually I did not found in mdadm read-only assembling mode which=
 will prevent such behavior!
>=20
> Best regards,
>                    Evgeny.
>=20


You want to use "ddrescue" which includes a log of bad blocks... (Be su=
re to use a logfile when you run ddrescue for each drive) It can often =
get all data off of failed drives because it will retry the bad blocks,=
 and if not it will hopefully only have a very small area.

When it is done, you could conceivably have some program to do a recove=
ry including the data in the log file to rebuild any other missing data=
=2E.. But I don't think such a program is written yet.

Essentially your first step is to recover as much of the actual data to=
 reliable disks as possible, then you will know what your situation rea=
lly is...

Sam--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
