From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Tue, 26 May 2015 12:18:09 +0100
Message-ID: <CAOS+5GHWktYuV2Q7NhsqybgFY5-QKRaGih0YcerD08_rKZp4Ng@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505261005260.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael

Very easy to understand......any way that requires entering the swaps
into /etc/fstab therefore means that if any drive and it's contained
swap fails the reboot can fail (plus the overhead of all those uuid
numbers in fstab).  My way means that as the swaps don't get loaded
unless the drive is alive the reboot has more resilience.



On 26 May 2015 at 09:06, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Tue, 26 May 2015, Another Sillyname wrote:
>
>> Not bothered about raiding the swap thanks, my way will suffice as it
>> gives me maximum flexibility and resilience......I'm not really
>> performance driven on this project.
>
>
> I don't see how running swap natively on the drives gives "maximum
> resilience". Higher resilience is gained by running raid1 for swap.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
