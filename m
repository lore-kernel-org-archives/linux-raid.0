From: Phil Turmel <philip@turmel.org>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Tue, 19 Feb 2013 12:48:33 -0500
Message-ID: <5123BAF1.1030600@turmel.org>
References: <20130219151921.320230@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130219151921.320230@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/19/2013 10:19 AM, Dragon wrote:
> Hello,
> sorry for pushing, but any further doing to rescue the raid? sorry but the system didnt run since Dec... 

I still think you are at the point where duplicating your original disks
onto backups so you can try the combinations I identified is the only
*safe* way forward.  But only *safe* in the sense that if your first
combination doesn't work, you can copy back and try another combination.

I've yet to see any indication that the moosefs on top of your broken
ext4 fs is likely to be saved.

You should post the links to the "fsck -n" results of creating the array
in the six combinations I had you try.

You should also repost the output of mdadm -D and mdadm -E from the
original array that you shared with me on Dec 17.

Phil

