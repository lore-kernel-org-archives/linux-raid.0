From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Seeking help fixing a failed array
Date: Sat, 24 May 2014 11:36:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1405241129020.29282@uplift.swm.pp.se>
References: <CAGcAkBKnp8J5zGuwgVv98zMrDLVPZWAi57rqpgLW6VByAcm94g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGcAkBKnp8J5zGuwgVv98zMrDLVPZWAi57rqpgLW6VByAcm94g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marnitz Gray <marnitz@xdesigns.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 May 2014, Marnitz Gray wrote:

> Hello good people of linux-raid.

Your output seems to indicate that you have one drive with an event count 
that is 6 events off the others. This most likely means it's safe to use 
--assemble --force in order to make this get accepted.

You didnt' state if you had space for more drives in your system, but you 
seem to have a recent mdadm and hopefully then a recent kernel, hook up 
the new drive to the system at the same time as the old one, add it as a 
spare, and use mdadm --replace. Then it'll online-replace the drive you 
want to change without degrading the array. This is a lot safer procedure.

Also consider going RAID6 if at all possible, you could do that when 
you're done replaceing all the drives with 3TB ones.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
