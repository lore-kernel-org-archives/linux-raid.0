From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Big mistake while changing a RAID5 disk (was Corrupted ext4
 filesystem ...)
Date: Mon, 5 May 2014 09:15:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1405050912410.29282@uplift.swm.pp.se>
References: <20140504103337.1db08101@netstation>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140504103337.1db08101@netstation>
Sender: linux-raid-owner@vger.kernel.org
To: "L.M.J" <linuxmasterjedi@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 4 May 2014, L.M.J wrote:

>  5) I'm not a mdadm expert, after a couple of minutes on Google, I've found a command who looked quite
>  good to me. I made a new partition on sdb (sdb1) and :

Where did you find this? 
https://raid.wiki.kernel.org/index.php/RAID_Recovery explicitly states not 
to do that unless as a last last resort.

It also has some hints about what you can do next (the permutate_array.pl 
script).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
