From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Tue, 26 May 2015 16:08:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1505261605450.9487@uplift.swm.pp.se>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
 <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se> <5561B237.4040709@youngman.org.uk> <5561BCA4.4060904@fnarfbargle.com> <5561C6E9.3060706@youngman.org.uk> <alpine.DEB.2.02.1505241604370.9487@uplift.swm.pp.se> <5561E5CE.7000304@youngman.org.uk>
 <alpine.DEB.2.02.1505241654580.9487@uplift.swm.pp.se> <CAOS+5GHz-4J_n7UAU1xVLWp3h7CRTuuSHdmP9rbL6=8=qx30CQ@mail.gmail.com> <5563AE50.4090806@youngman.org.uk> <CAOS+5GEBJ8dxF4s91dGmF7jx36LyNnu40UQZjLAmK2xVhqLAHw@mail.gmail.com> <alpine.DEB.2.02.1505261005260.9487@uplift.swm.pp.se>
 <CAOS+5GHWktYuV2Q7NhsqybgFY5-QKRaGih0YcerD08_rKZp4Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHWktYuV2Q7NhsqybgFY5-QKRaGih0YcerD08_rKZp4Ng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 May 2015, Another Sillyname wrote:

> Very easy to understand......any way that requires entering the swaps 
> into /etc/fstab therefore means that if any drive and it's contained 
> swap fails the reboot can fail (plus the overhead of all those uuid 
> numbers in fstab).  My way means that as the swaps don't get loaded 
> unless the drive is alive the reboot has more resilience.

If you have RAID1 for swap, you only need a single component drive to work 
for the RAID1 to be able to start. It also means any drive can fail and 
your swap information still works.

And I don't understand why you're referring to "overhead of all those uuid 
numbers in fstab". You're worried about 10-20 bytes extra in fstab???

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
