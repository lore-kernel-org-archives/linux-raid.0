From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Strange / inconsistent behavior with mdadm -I -R
Date: Wed, 27 Mar 2013 21:29:56 +0100
Message-ID: <515356C4.1000004@arcor.de>
References: <51422D10.3040000@arcor.de>	<20130318103510.45bdd4a8@notabene.brown>	<5148AE98.9020203@arcor.de>	<20130321122205.3fdca38c@notabene.brown> <20130327165332.7118740c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130327165332.7118740c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/27/2013 06:53 AM, NeilBrown wrote:

> I spend a while experimenting and such and I now have a patch which I am
> happy with and I think fixes your issue.  It is included below.
> 
> If you could test and confirm, I'd appreciate it.

It fixes my test case nicely, thanks. The behavior is now exactly the
same as in the container case, for both RAID10 and RAID1.

I'm not quite sure what else to test.

> I'll try to get to your DDF patches soon, but it might not be until next week.

Great, thanks and happy easter,
Martin
