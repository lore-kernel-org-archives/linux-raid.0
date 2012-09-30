From: EJ Vincent <ej@ejane.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Sun, 30 Sep 2012 15:25:15 -0400
Message-ID: <50689C9B.1010603@ejane.org>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se> <50689B6C.8000307@ejane.org> <CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/30/2012 3:22 PM, Mathias Bur=C3=A9n wrote:
> On 30 September 2012 20:20, EJ Vincent <ej@ejane.org> wrote:
>> On 9/30/2012 6:04 AM, Mikael Abrahamsson wrote:
>>> On Sun, 30 Sep 2012, EJ wrote:
>>>
>>>> Fast forward to now, I've upgraded the system to 12.04 LTS and hav=
e lost
>>>> access to my array. The array itself is a nine (9) disk raid6 mana=
ged by
>>>> mdadm.
>>>
>>> What version of kernel for 12.04 were you running?
>>>
>>> If you didn't upgrade your kernel, you might have been hit by the b=
ug
>>> described in:
>>>
>>> <http://neil.brown.name/blog/20120615073245>
>>>
>> Hello,
>>
>> I'm running the stock version of Ubuntu 12.04.0, using kernel
>> 3.2.0-23-generic.
>>
>> That link looks interesting-- I'm not sure if I triggered the bug ho=
w Mr.
>> Neil Brown describes it, but I definitely have symptoms on some (not=
 all)
>> the disks of RAID level "-unknown-" and devices appearing to be spar=
es.
>>
>> I'm hesitant to re-create the array again (using mdadm) because acco=
rding to
>> that blog post, for RAID-6, the order of devices are important, and =
with
>> this being a 9 disk array and no record of device order in logs or f=
rom my
>> own memory, I have no idea what the proper order might be.
>>
>> I do know that 1) I was using metadata version 1.2, 2) the array was=
 not
>> degraded and subsequently 3) no disks were missing.
>>
>> Am I over-estimating the importance of the order and should proceed =
with the
>> re-creation, or perhaps wait for Neil himself to weigh in the proble=
m?
>>
>> Thanks for all the responses, much appreciated.
>>
>> -EJ
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Can't you just boot off an older Ubuntu USB, install mdadm and scan /
> assemble, see the device order?

Hi Mathias,

I'm under the impression that damage to the metadata has already been=20
done by 12.04, making a recovery from an older version of Ubuntu=20
(10.04), impossible.  Is this line of thinking, flawed?

Thanks,

-EJ
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
