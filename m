From: Derek Vadala <derek@cynicism.com>
Subject: Re: ADD_NEW_DISK failed
Date: Mon, 24 Feb 2003 10:52:55 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030224155255.BA98C3B808@jaded.cynicism.com>
References: <15961.12440.64252.132242@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15961.12440.64252.132242@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 Feb 2003, Neil Brown wrote:

> Fourth paragraph of the "CREATE MODE" section:
>
>        To create a "degraded" array in which some devices are missing,  simply
>        give the word missing in place of a device name.  This will cause mdadm
>        to leave the corresponding slot in the array empty.   For  a  RAID4  or
>        RAID5  array  at most one slot can be missing.  For a RAID1 array, only
>        one real device needs to be given.  All of the others can be missing.

Perhaps an example immediately following this one or in the examples
section at the end of the manual page.

I hate to advocate something that rewards people for not RTFMing, but
since this is probably the single most asked question about mdadm, perhaps
some extra interactive logic would be helpful for this case.

The obvious,

	if --raid-devices > # of devices listed on the command line
		then ask if the user is trying to create a degraded array

seems like it might create more havoc for special cases though. I'm not
sure it's really a good alternative. Maybe it's just a good idea to refer
people to the section in the man page. Example:

	n.b.: For help with degraded arrays, see the corresponding entry
	in the manual page.


--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek


