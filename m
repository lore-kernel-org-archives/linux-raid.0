From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: reshape raid5 to raid6
Date: Thu, 9 Jul 2009 10:36:05 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0907091026110.15149@uplift.swm.pp.se>
References: <20090624102729.GY2828@rlogin.dk>  <972c997a386db1106868b3dc6b29ee21.squirrel@neil.brown.name>  <aebf5d970906240515y6c616250lca1cedea32927b00@mail.gmail.com> <aebf5d970906240517h783273b2t876fe2be09ef59d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970906240517h783273b2t876fe2be09ef59d6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Jun 2009, Beolach wrote:

> If a raid5 is changed to raid6, and then the raid6 is grown w/ 
> additional disks, will that switch it to a more traditional layout, 
> since it has to be re-striped anyway?

I'd greatly appreciate if someone in the know could answer this?

Also, this raid6 with all Q blocks on a single drive, will older kernels 
read this as well or is 2.6.30 needed to handle this "new" layout?

I'd like to convert a raid5 to raid6 with 2.6.30, then go back to 2.6.28 
and run it, then when I grow it next time, I'd like to get the "correct" 
layout with the Q blocks striped just as if I had created the raid6 from 
scratch. Is this possible?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
