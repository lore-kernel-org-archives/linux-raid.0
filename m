From: "Majed B." <majedb@gmail.com>
Subject: Re: [PATCH] barrier support for other md/raid levels
Date: Fri, 18 Sep 2009 23:18:07 +0300
Message-ID: <70ed7c3e0909181318v879ab30h5ffdf8e0b57799b4@mail.gmail.com>
References: <19123.9980.940255.937839@notabene.brown> <4AB372BA.6020101@redhat.com>
	<4D87015385157D4285D56CA6101072FF26C2CCB1@exchange07.valvesoftware.com>
	<4AB3D148.3060607@redhat.com> <87f94c370909181138g197be2fegd4032778ca6d3351@mail.gmail.com>
	<4AB3D4C8.1080602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB3D4C8.1080602@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46or what it's worth, I use XFS on one of my arrays, and whenever
mounting it, I get this error:

[ 2212.567725] Filesystem "dm-0": Disabling barriers, trial barrier wri=
te failed

So I guess you could use XFS to run your tests.

On Fri, Sep 18, 2009 at 9:43 PM, Ric Wheeler <rwheeler@redhat.com> wrot=
e:
> On 09/18/2009 02:38 PM, Greg Freemyer wrote:
>>
>> On Fri, Sep 18, 2009 at 2:28 PM, Ric Wheeler<rwheeler@redhat.com> =C2=
=A0wrote:
>>
>>>
>>> On 09/18/2009 02:19 PM, Chris Green wrote:
>>>
>>>>
>>>> It seems like what you'd need to robustly test barriers is some so=
rt of
>>>> barrier-supporting loopback device, which
>>>> acted correctly with barriers, but had worst-case behavior without=
 them
>>>> (buffering things for random arbitrarily long periods of time,
>>>> performing all operations in random order, etc).
>>>>
>>>>
>>>>
>>>>
>>>
>>> I think that it is pretty easy to get corruption (defined as fsck i=
ssues)
>>> if
>>> we have non-working barriers and do power fail testing. It is a bit
>>> tricky
>>> to automate that though but we are working on it,
>>>
>>> ric
>>>
>>
>> Ric,
>>
>> You are probably already using them to help automate the process, bu=
t
>> if you don't know computer controlled power switches are pretty
>> standard fare for computer clusters. =C2=A0I'm sure Redhat's cluster=
 team
>> has some.
>>
>> And the cluster team may also have scripts to test things like
>> unexpected power fails to one of the cluster members. =C2=A0It may n=
ot be
>> too hard to adjust those scripts to handle your needs.
>>
>> Greg
>>
>
> We definitely have those and do similar testing. It is a matter of ge=
tting a
> good work load and automating the regression testing.
>
> Chris's earlier test is a great starting point, HP has tests (hazard)=
 that
> do really mean things to storage as well.
>
> Just need to get time to get it all going :-)
>
> ric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
