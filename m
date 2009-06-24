From: Neil Brown <neilb@suse.de>
Subject: Re: help please
Date: Wed, 24 Jun 2009 13:29:02 +1000
Message-ID: <19009.40318.938280.11068@notabene.brown>
References: <OF4A69EBA3.01FB682F-ON852575DE.0051EB68-802575DE.00521E0F@pt.com>
	<efbcb4173b866e6407787256ba1ea15a.squirrel@neil.brown.name>
	<OF9266A41E.AA29AB09-ON852575DE.007396F5-802575DE.007403D4@pt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ken Rowe on Tuesday June 23
Sender: linux-raid-owner@vger.kernel.org
To: Ken Rowe <klr@pt.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 23, klr@pt.com wrote:
> Hi Neil,
> 
> thanks for the info, I am running a raid 1 configuration and when we lost 
> power we lose a drive from the raid and can never get it back unless we 
> manually force it back into the raid. The drive is marked as failed and 
> would like to know how you code behaves when the power is removed and why 
> the drive is removed and never returned and why it is tagged as failed.

This is still awefully short on real details.
 - cat /proc/mdstat often helps.
 - kernel logs might be useful here
 - exact command you use to 'for it back into the raid"

If the drive is marked as failed, that would be because an attempt to
write data to it failed.  Failed drives are never automatically added
back in to arrays as that would be a crazy thing to do.

NeilBrown
