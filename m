From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid 5 rebuild and Raid 6 reshape question
Date: Sun, 19 Apr 2015 10:43:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1504191041250.16871@uplift.swm.pp.se>
References: <6744821.j7csV3RJVE@balsa> <alpine.DEB.2.02.1504181511310.16871@uplift.swm.pp.se> <1454025.2pEa89kuvv@balsa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454025.2pEa89kuvv@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 18 Apr 2015, Thomas Fjellstrom wrote:

> problem. I was just curious as to how long an actual raid5->raid6 
> reshape would normally be or this setup. I expect it normally can take a 
> while as it has to rewrite a lot of data (11TiB worth).

In my experience it takes 5-15 times longer than a normal resync takes, to 
reshape from raid5->raid6. So for your 3TB disk size case, I'd say expect 
4-8 days or so.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
