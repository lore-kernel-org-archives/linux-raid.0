From: Gimpbully <gimpbully@gmail.com>
Subject: Re: array went wonky
Date: Thu, 2 May 2013 23:47:43 -0700
Message-ID: <91F4D0DD-926D-4337-B79C-08BA1141EF78@gmail.com>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com> <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>,<F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com> <71F985BA-11B9-45E8-A17B-03F9CB5C8F52@bingner.com> <517FD8FB.7000006@turmel.org> <59BD334D-D9B3-4856-AEF3-F033E511B0DD@gmail.com> <15E1BF3C-2361-4FC7-8D19-AA319C187AF5@gmail.com> <CF52FDBB-A0DA-4912-9352-3A742BBC273B@gmail.com> <724CACBC-1D7E-4EE0-91FE-97D5ADC0CD59@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <724CACBC-1D7E-4EE0-91FE-97D5ADC0CD59@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Sam Bingner <sam@bingner.com>, "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Anyone?  I'm so close I can taste it.  It looks like the superblocks on=
 the other disks think that sdf1 is still defined as a spare, but it's =
a ddrescue of what used to be /dev/sdc.  Is there a way to update the s=
uperblocks?

On May 2, 2013, at 7:29 AM, Gimpbully <gimpbully@gmail.com> wrote:

> Sorry, I realize I had md127 started.  So I stopped it and did the as=
semble and got the following (the problem is sdf isn't supposed to be a=
 spare at all, it's supposed to be a ddrescue'd sdc:
>=20
> eduardo ~ # mdadm --stop /dev/md127
> mdadm: stopped /dev/md127
> eduardo ~ # mdadm --assemble --force /dev/md127 /dev/sd{f,g,e,a}1
> mdadm: /dev/md127 assembled from 3 drives and 1 spare - not enough to=
 start the array.
> eduardo ~ #
>=20
>=20
> eduardo ~ # mdadm --examine /dev/sd{f,g,e,a}1 | egrep 'Event|/dev/sd'
> /dev/sdf1:
>         Events : 25979
> this     5       8       81        5      spare   /dev/sdf1
>   0     0       8       33        0      active sync   /dev/sdc1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> /dev/sdg1:
>         Events : 25979
> this     1       8       17        1      active sync   /dev/sdb1
>   0     0       8       33        0      active sync   /dev/sdc1
>   1     1       8       17        1      active sync   /dev/sdb1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> /dev/sde1:
>         Events : 25979
> this     2       8       65        2      active sync   /dev/sde1
>   0     0       8       33        0      active sync   /dev/sdc1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> /dev/sda1:
>         Events : 25979
> this     4       8        1        4      active sync   /dev/sda1
>   0     0       8       33        0      active sync   /dev/sdc1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
>=20
>=20
>=20
>=20
>=20
> On May 2, 2013, at 7:18 AM, Gimpbully <gimpbully@gmail.com> wrote:
>=20
>> This is very odd.  When trying to force an assemble, it's syaing no =
superblock on /dev/sdf1, but the --examine output appears to say otherw=
ise=85  Does anyone have any idea how to do this without doing a re-cre=
ation?
>>=20
>>=20
>> eduardo ~ # mdadm --examine /dev/sd{f,g,e,a}1 | egrep 'Event|/dev/sd=
'
>> /dev/sdf1:
>>        Events : 25979
>> this     5       8       81        5      spare   /dev/sdf1
>>  0     0       8       33        0      active sync   /dev/sdc1
>>  2     2       8       65        2      active sync   /dev/sde1
>>  4     4       8        1        4      active sync   /dev/sda1
>>  5     5       8       81        5      spare   /dev/sdf1
>> /dev/sdg1:
>>        Events : 25971
>> this     1       8       17        1      active sync   /dev/sdb1
>>  0     0       8       33        0      active sync   /dev/sdc1
>>  1     1       8       17        1      active sync   /dev/sdb1
>>  2     2       8       65        2      active sync   /dev/sde1
>>  4     4       8        1        4      active sync   /dev/sda1
>>  5     5       8       81        5      spare   /dev/sdf1
>> /dev/sde1:
>>        Events : 25979
>> this     2       8       65        2      active sync   /dev/sde1
>>  0     0       8       33        0      active sync   /dev/sdc1
>>  2     2       8       65        2      active sync   /dev/sde1
>>  4     4       8        1        4      active sync   /dev/sda1
>>  5     5       8       81        5      spare   /dev/sdf1
>> /dev/sda1:
>>        Events : 25979
>> this     4       8        1        4      active sync   /dev/sda1
>>  0     0       8       33        0      active sync   /dev/sdc1
>>  2     2       8       65        2      active sync   /dev/sde1
>>  4     4       8        1        4      active sync   /dev/sda1
>>  5     5       8       81        5      spare   /dev/sdf1
>> eduardo ~ #
>>=20
>>=20
>>=20
>> On May 1, 2013, at 11:59 AM, Gimpbully <gimpbully@gmail.com> wrote:
>>=20
>>> Alright, so I've ddrescued 2 disks now:
>>> sda - clean
>>> sdb - SMART errors, kicked out of array
>>> sdc - SMART errors, kicked out of array
>>> sde - ddrescued copy of sdb
>>> sdf - original failed disk, replaced.  is now a ddrescued copy of s=
dc
>>>=20
>>> So I run=20
>>>=20
>>> eduardo ~ # mdadm --assemble --force /dev/md127 /dev/sd{f,g,e,a}1
>>> mdadm: cannot open device /dev/sdf1: Device or resource busy
>>> mdadm: /dev/sdf1 has no superblock - assembly aborted
>>> eduardo ~ #=20
>>>=20
>>> Any ideas?
>>>=20
>>> On Apr 30, 2013, at 7:48 AM, Gimpbully <gimpbully@gmail.com> wrote:
>>>=20
>>>> I have no intentions of recreating at all.  I fully understand the=
 implications (I've had stripe orders go bad on truly massive scales be=
fore, I don't ever wanna experience that again), I just don't know mdad=
m as well as other vendor storage.
>>>>=20
>>>> I was able to ddrescue a copy of sdb with no errors.  I assembled =
the array and got a file system metadata dump (this is HUGE) and it's c=
urrently rebuilding before I even look at data.  Thank you all for your=
 help, patience was absolutely key here.
>>>>=20
>>>>=20
>>>> On Apr 30, 2013, at 7:45 AM, Phil Turmel <philip@turmel.org> wrote=
:
>>>>=20
>>>>> On 04/30/2013 02:20 AM, Sam Bingner wrote:
>>>>>> On Apr 29, 2013, at 4:33 PM, "Gimpbully" <gimpbully@gmail.com>
>>>>>> wrote:
>>>>>>> On Apr 13, 2013, at 7:20 AM, Sam Bingner <sam@bingner.com> wrot=
e:
>>>>>>>=20
>>>>>>>> After that you can try to recreate the array with the proper
>>>>>>>> order (sdc1, sdb1, sde1, missing, sda1) and copy data off or a=
dd
>>>>>>>> the spare in again depending on if you were able to recover al=
l
>>>>>>>> the data wih GNU ddrescue.
>>>>>>>=20
>>>>>>>=20
>>>>>>> What do you mean recreate?  what's the specific command?  somet=
hing
>>>>>>> like:
>>>>>>> mdadm --create --assume-clean --level=3D5 --raid-devices=3D5 /d=
ev/md127
>>>>>>> /dev/sdc1 /dev/sdb1 /sdv/sde1 missing  /dev/sda1
>>>>>>=20
>>>>>> Don't recreate it - I said the wrong thing... You want to do an
>>>>>> assemble on them with force if possible... Recreate is last ditc=
h and
>>>>>> make sure you have another copy if you do the previous command i=
n
>>>>>> case it doesn't work right due to offsets etc...
>>>>>>=20
>>>>>> try:
>>>>>> mdadm --stop /dev/md127
>>>>>> mdadm --assemble --force /dev/md127 /dev/sd{c,b,e,a}1
>>>>>=20
>>>>> Yes.
>>>>>=20
>>>>>> If you DO need to recreate it, what you showed looks correct.
>>>>>=20
>>>>> NO!
>>>>>=20
>>>>> The OP has *not* shared sufficient information on the array membe=
rs to
>>>>> say that.  Since it has "worked for years", the odds of an offset=
 error
>>>>> is *very* high.  Chunk size defaults are also likely to be differ=
ent.
>>>>>=20
>>>>> *Complete* output of "mdadm -E" for the array members is needed b=
efore
>>>>> any "--create" operation is attempted.  Plus the distro info, ker=
nel
>>>>> version, and mdadm version .
>>>>>=20
>>>>> Phil
>>>>=20
>>>=20
>>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
