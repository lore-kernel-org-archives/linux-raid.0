From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID performance
Date: Mon, 11 Feb 2013 05:33:14 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302110531340.32644@uplift.swm.pp.se>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com>
 <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com>
 <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <alpine.DEB.2.00.1302101812060.32644@uplift.swm.pp.se> <511817D8.7020809@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511817D8.7020809@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 11 Feb 2013, Adam Goryachev wrote:

> If I use a 10G connection for the SAN, and multiple 1G connections for 
> the clients, then I will still end up with a max of 1G read speed, since 
> the switch will only deliver data on a single port. So to get better 
> than 1G speed, I must use higher bandwidth channels, but using 10G on 
> all machines allows a single server to "flood" the network...

If your equipment supports it, you should put in some kind of policer to 
rate-limit traffic based on destination (or the whole port). Then you 
could limit each server to 2-3 gigabit/s on their 10G port, and the file 
server could get its entire 10G port (or limit that to 5-6 gigabit/s).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
