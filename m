From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 08:52:17 -0700
Message-ID: <m2q40b437201004210852k34ce5aaco468b36c3a35b7f3c@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com>
	 <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>
	 <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net>
	 <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>
	 <4BCEFB99.9080806@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCEFB99.9080806@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 21, 2010 at 6:20 AM, Bill Davidsen <davidsen@tmr.com> wrote=
:
> Phillip Susi wrote:
>>
>> On 4/14/2010 3:53 PM, Bill Davidsen wrote:
>>
>>>
>>> Stefan *St0fF* Huebner wrote:
>>>
>>>>
>>>> Am 25.03.2010 18:45, schrieb Asdo:
>>>>
>>>>>
>>>>> David Lethe wrote:
>>>>>
>>>>>>
>>>>>> On Mar 25, 2010, at 11:20 AM, Andrew Dunn wrote:
>>>>>>
>>>>>>>
>>>>>>> Recently Dell is selling their WD20EARS (2TB) for 90$
>>>>>>>
>>>>>>> This being one of the best PPG (Price Per Gigabyte) snatches I =
have
>>>>>>> seen, I was considering buying 8 of them for an mdadm array.
>>>>>>>
>>>>>>> Has anyone had experience with these drives?
>>>>>>>
>>
>> I believe that these disks only come in the "green" variety. =A0I re=
cently
>> picked up a 1.5 tb version for testing and cheap bulk storage, and I
>> would not suggest using them in a raid array because the green drive=
s
>> firmware automatically parks the head after 8 seconds of inactivity =
and
>> reduces the rpm of the disk. =A0The constant parking can quickly wea=
r out
>> the head under high use and there is no way to disable this "feature=
".
>>
>
> I hear this said, but I don't have any data to back it up. Drive vend=
ors
> aren't stupid, so if the parking feature is likely to cause premature
> failures under warranty, I would expect that the feature would not be=
 there,
> or that the drive would be made more robust. Maybe I have too much fa=
ith in
> greed as a design goal, but I have to wonder if load cycles are as
> destructive as seems to be the assumption.
>
> I'd love to find some real data, anecdotal stories about older drives=
 are
> not overly helpful. Clearly there is a trade-off between energy savin=
g,
> response, and durability, I just don't have any data from a large pop=
ulation
> of new (green) drives.


It's not hard data, but there was discussion of a similar issue fours
years ago related to load/unload cycles on laptops under Ubuntu:
https://bugs.launchpad.net/ubuntu/+source/acpi-support/+bug/59695

Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
