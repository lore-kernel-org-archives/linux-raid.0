From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Tue, 26 May 2015 22:02:32 +0100
Message-ID: <CAOS+5GGEfx7faY7jt+SeDikrO=iV714PPDPoLsB0wt5rOOOg8Q@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<555294A0.6040703@websitemanagers.com.au>
	<CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
	<CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
	<alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
	<5561B237.4040709@youngman.org.uk>
	<5561BCA4.4060904@fnarfbargle.com>
	<5561C6E9.3060706@youngman.org.uk>
	<alpine.DEB.2.02.1505241604370.9487@uplift.swm.pp.se>
	<5561E5CE.7000304@youngman.org.uk>
	<alpine.DEB.2.02.1505241654580.9487@uplift.swm.pp.se>
	<CAOS+5GHz-4J_n7UAU1xVLWp3h7CRTuuSHdmP9rbL6=8=qx30CQ@mail.gmail.com>
	<5563AE50.4090806@youngman.org.uk>
	<CAOS+5GEBJ8dxF4s91dGmF7jx36LyNnu40UQZjLAmK2xVhqLAHw@mail.gmail.com>
	<alpine.DEB.2.02.1505261005260.9487@uplift.swm.pp.se>
	<CAOS+5GHWktYuV2Q7NhsqybgFY5-QKRaGih0YcerD08_rKZp4Ng@mail.gmail.com>
	<alpine.DEB.2.02.1505261605450.9487@uplift.swm.pp.se>
	<5564D373.30705@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5564D373.30705@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guys

Without wishing to sound like the list police (no-one expects the list
police!!) this has drifted off topic into a fairly unimportant
area.....I've made my decision and will live with the consequences for
now.  As I'm currently 10 hours into a circa 40 hour 20TB data copy
you can all rest assured nothing short of a catastrophic failure is
going to change the current setup......when I get another test box in
a couple of weeks I'll revisit.

Until then thanks for all the help but can we let this lie please.

Tony

On 26 May 2015 at 21:11, Wols Lists <antlists@youngman.org.uk> wrote:
> On 26/05/15 15:08, Mikael Abrahamsson wrote:
>> On Tue, 26 May 2015, Another Sillyname wrote:
>>
>>> Very easy to understand......any way that requires entering the swaps
>>> into /etc/fstab therefore means that if any drive and it's contained
>>> swap fails the reboot can fail (plus the overhead of all those uuid
>>> numbers in fstab).  My way means that as the swaps don't get loaded
>>> unless the drive is alive the reboot has more resilience.
>>
>> If you have RAID1 for swap, you only need a single component drive to
>> work for the RAID1 to be able to start. It also means any drive can fail
>> and your swap information still works.
>
> And you're wasting a lot of disk space. What's important to you (that a
> live swap disk shouldn't fail) is not important to me and doesn't seem
> to be important to Another Sillyname.
>
> My disk drives have 32Gb swap partitions. Overkill? Dunno. But I'd
> rather linux raid 0's them for 64Gb swap than mdadm raid 1's them for
> 32Gb swap. I have a couple of 20Gb tmpfs partitions :-)
>
> I don't know why Another Sillyname wants to chain his swap partitions,
> but it's his choice. Maybe like me, his system gets rebooted a couple of
> times a day, and failure to start is a far more real risk than failure
> in use. He's running Fedora - that seems likely then ...
>
> Cheers,
> Wol
