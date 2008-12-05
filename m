From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 05 Dec 2008 23:12:44 +0100
Message-ID: <4939A75C.6050705@rabbit.us>
References: <1228510833.16555.76.camel@localhost>	 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>	 <1228511195.16555.78.camel@localhost>	 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>	 <1228511558.16555.84.camel@localhost> <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBQcnp5xYJ1c2tp?= <mikylie@gmail.com>
Cc: Redeeman <redeeman@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Micha=C5=82 Przy=C5=82uski wrote:
> Hi,
>=20
> 2008/12/5 Redeeman <redeeman@metanurb.dk>:
>> On Fri, 2008-12-05 at 16:09 -0500, Justin Piszcz wrote:
>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>
>>>> On Fri, 2008-12-05 at 16:02 -0500, Justin Piszcz wrote:
>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>>
>>>>>> Hello.
>>>>>>
>>>>>> I was looking at the PDFs linked to from the wiki, and found thi=
s:
>>>>>> http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
>>>>>>
>>>>>> More specifically, section 4, starting on page 8.
>>>>>>
>>>>>> Am I understanding this correctly, in that with raid6, linux is =
capable
>>>>>> of detecting if the content on 1 disk is corrupted, and reconstr=
uct it
>>>>>> from the remaining disks?
>>>>> I ran md/raid6 for awhile, do you mean remap the bad sector on th=
e fly?
>>>>> Linux/md raid does not do this afaik.
>>>> No, i mean, if one disk does silent corruption
>>> What would the error look like?  Both md/Linux & in the 3ware manua=
l
>>> recommend you run a 'check' across the raid at least once a week
>>> (3ware/raid-verify) and md/Linux in Debian runs a check once a mont=
h I
>>> believe to eliminate these issues.
>>>
>>> If you are asking whether a read error of a latent sector from the =
one
>>> disk will result it reading the data from the second disk that is a=
 good
>>> question.
>> im asking, if one disk in a raid6 setup suddenly decides to flip a f=
ew
>> bits in some bytes, will it be able to detect that in a scan, and
>> correct it? i cant see how it can do it on raid5, but maybe raid6?
>=20
> No, not really.
> I've been investigating silent corruption for a quite a while now, an=
d
> it looks more or less like this.
> During a "check" action it'll be detected. During normal operation -
> it won't be detected.
> Normal (non-degraded) raid5/6 reads don't read parity (or Q syndrome)=
,
> they just read data. So they have no idea that something went bad.
> Now, worse news is that you cannot really fix it automagically, even
> after detecting by a "check" procedure. A "repair" will overwrite
> parity and Q syndrome, with new values (new =3D calculated from what =
it
> seems to be data blocks).
>=20
> It is possible (by the theory of Q syndrome, per the article you
> linked) to detect which drive is doing a silent corruption with raid6
> (and with some extra assumption, that just one drive is doing that).
> But it's not implemented.
>=20

I'd like to shamelessly bring in an older related thread:
http://marc.info/?l=3Dlinux-raid&m=3D120605458309825
http://marc.info/?l=3Dlinux-raid&m=3D120618020817057

Maybe someone will get inspired, and will actually write the damned thi=
ng :)

Cheers
Peter
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
