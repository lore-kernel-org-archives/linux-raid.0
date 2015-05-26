From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Tue, 26 May 2015 10:06:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1505261005260.9487@uplift.swm.pp.se>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com> <555294A0.6040703@websitemanagers.com.au> <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com> <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
 <alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se> <5561B237.4040709@youngman.org.uk> <5561BCA4.4060904@fnarfbargle.com> <5561C6E9.3060706@youngman.org.uk> <alpine.DEB.2.02.1505241604370.9487@uplift.swm.pp.se> <5561E5CE.7000304@youngman.org.uk>
 <alpine.DEB.2.02.1505241654580.9487@uplift.swm.pp.se> <CAOS+5GHz-4J_n7UAU1xVLWp3h7CRTuuSHdmP9rbL6=8=qx30CQ@mail.gmail.com> <5563AE50.4090806@youngman.org.uk> <CAOS+5GEBJ8dxF4s91dGmF7jx36LyNnu40UQZjLAmK2xVhqLAHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GEBJ8dxF4s91dGmF7jx36LyNnu40UQZjLAmK2xVhqLAHw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 May 2015, Another Sillyname wrote:

> Not bothered about raiding the swap thanks, my way will suffice as it
> gives me maximum flexibility and resilience......I'm not really
> performance driven on this project.

I don't see how running swap natively on the drives gives "maximum 
resilience". Higher resilience is gained by running raid1 for swap.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
