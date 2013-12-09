From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: [SOLVED] Re: Raid1 where Event Count off my 1 cannot assemble
 --force
Date: Mon, 9 Dec 2013 08:40:13 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1312090839360.24602@uplift.swm.pp.se>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com> <20131209120040.6464b91b@notabene.brown> <52A546DB.3090605@suddenlinkmail.com>
 <20131209154639.3b9f801c@notabene.brown> <52A5531B.6080702@suddenlinkmail.com> <20131209164005.0e9ea273@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209164005.0e9ea273@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 9 Dec 2013, NeilBrown wrote:

> But yes, it doesn't hurt to add it to a wiki page somewhere.

I added this text to the wiki:

"There are bugs in older versions of mdadm, and a lot of "stable" 
operating system releases ship with really old mdadm versions. Recent 
versions are 3.2.x and 3.3.x. It's advisable if you run into problems 
assembling your raid to upgrade to the latest git version of mdadm. If you 
can get the raid to successfully assemble and recover with the git 
version, then it's fine to use your old mdadm version again for normal 
system operation. Newer mdadm doesn't make any changes to the array that 
isn't backwards compatible."

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
