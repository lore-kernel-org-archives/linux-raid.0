From: "Thomas Gebhardt" <gebhardt@HRZ.Uni-Marburg.DE>
Subject: Re: md.c Kernel BUG(?) and reboot segfault
Date: Thu, 31 Oct 2002 12:41:11 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210311141.g9VBfBVP006467@pcrz175.hrz.uni-marburg.de>
References: <15804.28438.676002.891659@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: neilb's message of Mon, 28 Oct 2002 09:56:22 +1100.
	     <15804.28438.676002.891659@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> > md: marking sb clean
> > kernel BUG at md.c:1251!
> 
> Line 1251 of md.c in 2.4.19 doesn't have a 'BUG' sop the 'jp Patches'
> must have moved things around.  Maybe if you could send me a copy of
> you md.c.....
> 
> NeilBrown

You're right. The bug does not appear when installing a vanilla
2.4.19 kernel. Actually the flaw is introduced by no. 026 of
the jp-14 patch set (026_raid-md-locks-2)
 -> Improve locking of MD related structure, particularly when reconfiguring
The "BUG" appears when applying this single patch: kernel BUG at md.c:1075

http://cgi.cse.unsw.edu.au/~neilb/patches/linux-stable/2.4.19-release/patch-W-MdLocks works fine, though.

Cheers and thanks, Thomas


