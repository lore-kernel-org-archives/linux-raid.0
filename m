From: "Garth Snyder" <garth@grsweb.us>
Subject: RE: Spare fails to transfer between RAID groups
Date: Wed, 13 May 2009 14:49:43 -0700
Message-ID: <006401c9d414$bc068c70$3413a550$@us>
References: <001901c9d202$709acad0$51d06070$@us>	<18952.46349.611683.608352@notabene.brown>	<007c01c9d34c$9a618f70$cf24ae50$@us> <18954.43504.87590.384746@notabene.brown>
Reply-To: <garth@grsweb.us>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.43504.87590.384746@notabene.brown>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wrote: 

> I patched the 2.6.7.1 tree, which was Jaunty's default for "apt-get source
> mdadm" (and the same version included in the binary package). Manage.c and
> Monitor.c already matched the "after" state of your patch, so the only
code
> that actually changed was the one-liners in super0.c and super1.c.

Neil Brown replied:

> That is impossible. I had only just written that patch, so there is
> no way the 'after' bit could possibly be in Jaunty.

Sorry, my mistake - I received error messages when applying the Manage.c and
Monitor.c portions, so I thought that the patches hadn't been applied when I
inspected the files. I am in fact running the complete set of patches to all
four files and that's what's been working for me.

Garth


