From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: New features?
Date: Fri, 3 Nov 2006 10:33:42 +0100
Message-ID: <20061103093342.GI25422@boogie.lpds.sztaki.hu>
References: <20061031214301.GB17958@timor.isp-services.nl> <17738.47603.308198.941749@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17738.47603.308198.941749@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Frido Ferdinand <frido@zolder.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 03, 2006 at 02:39:31PM +1100, Neil Brown wrote:

> mdadm could probably be changed to be able to remove the device
> anyway.  The only difficulty is: how do you tell it which device to
> remove", given that there is no name in /dev to use.
> Suggestions?

Major:minor? If /sys/block still holds an entry for the removed disk,
then the user can figure it out from the name. Or mdadm could just
accept a path under /sys/block instead of a device node.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
