From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: Re: &quot;failed&quot; vs &quot;removed&quot; or &quot;locked-out&quot; state and --incremental auto-re-adding
Date: Mon, 26 Apr 2010 22:28:37 +0000 (UTC)
Message-ID: <loom.20100427T002749-963@post.gmane.org>
References: <loom.20100423T140059-877@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


As comming to "terms" working with mdadm took me a while, I'll add my current
"translations" of the actions to the discussion:

1) The "failed" state is the state a member that failed or is missing gets,
while it can stay listed in mdstat.

2) To "unbind", "unlist" or "dismiss" a member from the md device stats is
currently called to --remove it. In particular you can "unbind", "unlist" or
"dismiss" failed or detatched members with --remove failed/detached.

3) A safe way to "lock-out" or "really remove" members from udev/--incremental
assembly is not available yet AFAIK. (--zero-superblock on mirror members makes
the md device content detectable/available directly)


IMHO the ones mentioned first could seen as implied by those mentioned later.

I am unclear why --incremental seems to require a device to be unbound first
(--removed) in order to re-add it after it failed. IMHO it could do it itself if
it is really necessary without bothering the user.



