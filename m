From: Neil Brown <neilb@suse.de>
Subject: Re: New features?
Date: Fri, 10 Nov 2006 11:48:22 +1100
Message-ID: <17747.52310.97538.80404@cse.unsw.edu.au>
References: <20061031214301.GB17958@timor.isp-services.nl>
	<17738.47603.308198.941749@cse.unsw.edu.au>
	<20061103093342.GI25422@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gabor Gombas on Friday November 3
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Frido Ferdinand <frido@zolder.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 3, gombasg@sztaki.hu wrote:
> On Fri, Nov 03, 2006 at 02:39:31PM +1100, Neil Brown wrote:
> 
> > mdadm could probably be changed to be able to remove the device
> > anyway.  The only difficulty is: how do you tell it which device to
> > remove", given that there is no name in /dev to use.
> > Suggestions?
> 
> Major:minor? If /sys/block still holds an entry for the removed disk,
> then the user can figure it out from the name. Or mdadm could just
> accept a path under /sys/block instead of a device node.

I like the /sys/block idea.  So if given a directory we look for a
'dev' file and read major:minor from that.
I guess I could also just allow
  mdadm /dev/mdX --remove failed

and all failed devices get removed.

Thanks for the suggestion.
NeilBrown
