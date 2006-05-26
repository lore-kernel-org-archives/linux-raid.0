From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 09:57:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0605260956120.20178@uplift.swm.pp.se>
References: <1148571503.2772.35.camel@hendrix.hollabaugh.com>
 <17526.7947.129968.287311@cse.unsw.edu.au> <1148596237.4957.4.camel@hendrix.hollabaugh.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1148596237.4957.4.camel@hendrix.hollabaugh.com>
Sender: linux-raid-owner@vger.kernel.org
To: Craig Hollabaugh <craig@hollabaugh.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 May 2006, Craig Hollabaugh wrote:

> That did it! I set the partition FS Types from 'Linux' to 'Linux raid 
> autodetect' after my last re-sync completed. Manually stopped and 
> started the array. Things looked good, so I crossed my fingers and 
> rebooted. The kernel found all the drives and all is happy here in 
> Colorado.

Would it make sense for the raid code to somehow warn in the log when a 
device in a raid set doesn't have "Linux raid autodetect" partition type? 
If this was in "dmesg", would you have spotted the problem before?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
