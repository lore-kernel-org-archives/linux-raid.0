From: David Nedved <dnedved@nuvox.net>
Subject: Re: RAID-1 md comes up degraded every time
Date: Sun, 9 Jun 2002 12:13:37 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020609121337.A30774@nuvox.net>
References: <20020608110645.A16350@nuvox.net> <Pine.LNX.4.30.0206081830520.278-100000@mail.teamwerk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.30.0206081830520.278-100000@mail.teamwerk.com>; from andre.breiler@teamwerk.com on Sat, Jun 08, 2002 at 06:41:24PM +0200
To: Andre Breiler <andre.breiler@teamwerk.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jun 08, 2002 at 06:41:24PM +0200, Andre Breiler wrote:
> Is seems that autorun dosn't sees hdg1. Could it be that the partition
> type isn't 0xfd ?

Bingo!  You hit the nail on the head.  Fixed it and it works great.

Thanks!

David

> 
> Vye Andre'
> -- 
> eMail: andre.breiler@teamwerk.com | teamWERK GmbH
> Phone: +49 34206 75462            | Andre' Breiler
> Fax:   +49 34206 75470            | Guentzelstrassse 4
> /bin/bash -c ':(){ :|:&};:'       | 04571 Roetha
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
