From: David Nedved <dnedved@nuvox.net>
Subject: Re: RAID-1 md comes up degraded every time
Date: Sun, 9 Jun 2002 12:14:06 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020609121406.B30774@nuvox.net>
References: <Pine.LNX.4.33.0206081035540.23582-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206081035540.23582-100000@pandora.is.bizsystems.com>; from michael@bizsystems.com on Sat, Jun 08, 2002 at 10:37:42AM -0700
To: Michael Robinton <michael@bizsystems.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Same thing here!  Changed it and it works fine now.

Thanks!

David

On Sat, Jun 08, 2002 at 10:37:42AM -0700, Michael Robinton wrote:
> 
> the one time this happened to me, I'd forgotten to marke the partition as
> "FD"
> 
> Michael
> 
> I created a RAID-1 volume on Linux 2.4.18 by creating the volume in
> degraded
> mode, then hot-adding the second disk.  It syncs up fine, but every time I
> reboot, it comes back in degraded mode.  Can someone help me figure out
> what
> I'm doing wrong?
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
   __   __   __ _ __ __      __  __ ____ __   __ _ ____ __
  /  | /, | / / // //  |    /  |/ // __//  | / / // __//  |
 / / //   // / // // / /   / , ' // _/ / / // / // _/ / / /
/___//_/_/ |__//_//___/   /_/|__//___//___/ |__//___//___/

Unix Systems Engineer              VOICE: +1 864 331 8181
NuVox Communications, Inc.         FAX:   +1 864 331 7234
301 North Main Street, Ste 5000    EMAIL: dnedved@nuvox.net
Greenville, SC  29601   USA        PAGER: pagenedved@nuvox.net
