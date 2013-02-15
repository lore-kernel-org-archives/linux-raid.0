From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 19:14:24 +0800
Message-ID: <511E1890.6060708@fnarfbargle.com>
References: <20130214213908.282850@gmx.net> <alpine.DEB.2.00.1302151055500.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302151055500.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/02/13 17:57, Mikael Abrahamsson wrote:
> On Thu, 14 Feb 2013, Dragon wrote:
>
>> I heart that -force could be result in more problems - right? i do
>> asswell:
>
> Compared to the trouble people get into when getting --create
> --assume-clean and getting it wrong, I'd say --force is *nothing*.
>
> --force needs drives that have similar event count, if they're too far
> apart (one drive for instance), then that specific drive shouldn't be
> used when assembling.
>

To the point I've been ready to submit a patch for --assume-clean along 
the lines of what hdparm does and makes you also attach 
--please-destroy-my-disk before it'll work.

--assume-clean is great for those that need it, but for the great 
majority who rely on google and wikis it's a data-destroyer.

Not mdadm's fault however. More the twits who wrote the wikis.
