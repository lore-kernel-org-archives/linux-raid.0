From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 16:57:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1505241654580.9487@uplift.swm.pp.se>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
 <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se> <5561B237.4040709@youngman.org.uk> <5561BCA4.4060904@fnarfbargle.com> <5561C6E9.3060706@youngman.org.uk> <alpine.DEB.2.02.1505241604370.9487@uplift.swm.pp.se> <5561E5CE.7000304@youngman.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5561E5CE.7000304@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Brad Campbell <brad@fnarfbargle.com>, Another Sillyname <anothersname@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 24 May 2015, Wols Lists wrote:

> On 24/05/15 15:06, Mikael Abrahamsson wrote:
>> On Sun, 24 May 2015, Wols Lists wrote:
>>
>>> And if you get read errors, well, aiui, raid won't help here either -
>>> especially with mirrored raid, you just get a read failure. Raid does
>>> NOT give you error recovery unless the drive physically fails, and if
>>> it's a bad block it gets fixed at the disk or disk driver level - well
>>> below the raid driver.
>>
>> You're wrong. In case of a read error from the physical drive on RAID1,
>> RAID5 or RAID6 then the information will be re-created from another
>> drive, and written to the drive that threw a read error. This is the
>> whole point of RAID with parity information.
>>
> Except raid 1 isn't parity ... :-)

RAID1 means every drive will have the same information, it's mirrored 
between the member disks. What do you think RAID1 is?

> Personally, I still don't think "raid"ing swap is worth it, though.
> Horses for courses, ram is cheap, and in my circumstances I don't think
> I'd gain anything.

You're welcome to believe anything you want, but if you're publically 
telling people things that are just not true then you should expect to be 
told so.

You're welcome to tell people to not use SWAP at all, but telling people 
RAID1 has no benefit for SWAP because it won't protect you from read 
erorrs is just wrong.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
