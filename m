From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Tue, 6 Mar 2007 11:01:49 +0100
Message-ID: <20070306100149.GG14942@boogie.lpds.sztaki.hu>
References: <45E82EF8.9000106@laurelnetworks.com> <9782.20070302161004.GE31010@boogie.lpds.sztaki.hu> <45ECA890.5000701@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45ECA890.5000701@laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 05, 2007 at 06:32:32PM -0500, Mike Accetta wrote:

> Yes, we actually have a separate (smallish) boot partition at the front of
> the array.  This does reduce the at-risk window substantially.  I'll have to
> ponder whether it reduces it close enough to negligible to then ignore, but
> that is indeed a good point to consider.

Replacing a failed disk requires a human to pull out the old disk and
insert the new one. The /boot partition should resync in less than 1
minute (if not, it's _way_ too big), so the same human should still be
around to kick the machine if something goes wrong.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
