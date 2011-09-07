From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] udev rules behaviour
Date: Wed, 7 Sep 2011 14:00:02 +1000
Message-ID: <20110907140002.0792061c@notabene.brown>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun,  4 Sep 2011 14:42:42 +0200 Michal Soltys <soltys@ziu.info> wrote:

> Current udev rules installed cause autoassembly of everything that is possible
> during coldplug - due to mdadm -I calls for each matching device.
> 
> This causes two immediate problems:
> 
> - mdadm.conf kind-of rendered pointless, as the assembly of any array will be
>   attempted either way
> 
> - 65-md-inc*.rules (e.g. present in dracut and different distributions)
>   offering more fine grained controls (e.g. incremental assembly limited to
>   certain uuids) are also shadowed by mdadm's default rules
> 
> If this is not expected behaviour, following patch removes -I calls.
> Second patch adds ddf (and any future) containers to -If calls.
> 
> 
> Alternatively, we could detect presence of 65-md-inc* and mdadm.conf and
> attempt assemlby only if none of those are present ? Not perfect, but
> a bit more flexible.
> 

hi Michal,
 thanks for raising this.

I find it unfortunate that someone would ship an md-specific rules file
without even discussing it with me or on this list.  That can easily lead to
inconsistent or suboptimal behaviour.

It isn't entirely true that calling "mdadm -I" on all devices makes
mdadm.conf pointless.
If you put "auto -all" in mdadm.conf it will disable all auto-assembly and
will only assemble arrays that are explicitly listed in mdadm.conf.

So I'm not really sure what that problem is here.

Can you give me an example of a situation that cannot be handled with the
mdadm udev rules as they are?

I like your "shorten remove rules" patch and will apply that.

Thanks,
NeilBrown


