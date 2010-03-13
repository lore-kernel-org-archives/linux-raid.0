From: "Majed B." <majedb@gmail.com>
Subject: Re: Growing after replacing with larger discs
Date: Sun, 14 Mar 2010 00:00:04 +0300
Message-ID: <70ed7c3e1003131300i4c2ed3dasafcbf49e44920fd1@mail.gmail.com>
References: <4B9A7C63.6090202@anonymous.org.uk> <aebf5d971003131242q234a6c5ct441dd995a9c6a541@mail.gmail.com>
	<aebf5d971003131245m477d05dfpcb5f2c7dfcb0820a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d971003131245m477d05dfpcb5f2c7dfcb0820a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Beolach,

That involves double the work!

On Sat, Mar 13, 2010 at 11:45 PM, Beolach <beolach@gmail.com> wrote:
> Forgot to send to the list...
>
> On Sat, Mar 13, 2010 at 13:42, Beolach <beolach@gmail.com> wrote:
>> On Fri, Mar 12, 2010 at 10:39, John Robinson
>> <john.robinson@anonymous.org.uk> wrote:
>>> Before I have to go to a customer's premises and try it, I wanted t=
o ask if
>>> anyone had already done anything like this: I have a CentOS 5 syste=
m with
>>> 0.90 metadata and type fd partitions with RAID-5 over 3 discs. I wa=
nt to
>>> grow it by replacing the drives. If I dd the small partitions onto =
larger
>>> ones on the new discs, then reboot, will the system recognise the R=
AID-5 -
>>> which now has its metadata somewhere in the middle of the paritions=
 not at
>>> the end - so that I can then --grow?
>>>
>>
>> I have no idea if this would actually work, but maybe try partitioni=
ng
>> the new, larger drives so the partitions are identical in size to th=
e
>> old discs, copying the old discs to the new partitions, starting the
>> array with the new partitions, resizing the new partitions, and then
>> running --grow. =C2=A0If mdadm can re-check the size of the member d=
evices
>> of a running array at --grow time, this might work, but if it only
>> checks member device sizes at creation or assemble time, then it
>> probably won't.
>>
>>
>> Good luck,
>> Conway S. Smith
>>
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
