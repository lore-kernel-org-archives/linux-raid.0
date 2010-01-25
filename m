From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Swapping a disk without degrading an array
Date: Mon, 25 Jan 2010 13:53:16 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001251350100.15329@uplift.swm.pp.se>
References: <1264421475.30742.49.camel@test.apertos.eu> <70ed7c3e1001250425n6b6136ddr261a95042584df72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1001250425n6b6136ddr261a95042584df72@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: =?ISO-8859-2?Q?Micha=B3_Sawicz?= <michal@sawicz.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 25 Jan 2010, Majed B. wrote:

> Though I'm not sure if it's feasible to nest raids or have a disk to be 
> a member of 2 arrays at the same time.

I think the proposal is for the scenario when a drive is being upgraded to 
a larger sized drive.

So:

1 Add spare X
2 Tell mdadm to replace drive N with the new spare
3 Information on N is now copied to X online
4 When copy is done, N and X contains the same info, and N is now 
converted to spare by mdadm
5 Hot-remove N

This means if I want to upgrade from size to size+X drives I can do that 
without ever degrading the array.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
