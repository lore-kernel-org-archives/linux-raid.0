From: "Garth Snyder" <garth@grsweb.us>
Subject: RE: Spare fails to transfer between RAID groups
Date: Tue, 12 May 2009 14:57:07 -0700
Message-ID: <007c01c9d34c$9a618f70$cf24ae50$@us>
References: <001901c9d202$709acad0$51d06070$@us> <18952.46349.611683.608352@notabene.brown>
Reply-To: <garth@grsweb.us>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18952.46349.611683.608352@notabene.brown>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 10, I (garth@grsweb.us) wrote:

> I'm having a problem getting a spare partition moved to the right RAID
group
> after a failure...All superblocks involved are version 1.2.

Neil Brown replied:

> This would be because no one has tried the spare-group feature with
> 1.x metadata yet...The following patch should make it work...This patch
> is against 2.6.9, though it should apply to any reasonably recent 2.x
mdadm.

Thanks for the response, Neil. The patch works great; now I get Fail,
MoveSpare, and Rebuild events in sequence with no errors. /proc/mdstat shows
that the appropriate spare was moved into the failed array and that the
array is being rebuilt onto it.

I patched the 2.6.7.1 tree, which was Jaunty's default for "apt-get source
mdadm" (and the same version included in the binary package). Manage.c and
Monitor.c already matched the "after" state of your patch, so the only code
that actually changed was the one-liners in super0.c and super1.c.

Thanks for the lightning-fast patch, and please let me know if there's
anything more I can do to help validate the fix.

Cheers,
Garth


