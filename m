From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fwd: Failed Raid6 Array.....want some guidance before attempting
 restart
Date: Sun, 20 Sep 2015 11:54:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1509201153490.8750@uplift.swm.pp.se>
References: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com> <alpine.DEB.2.02.1509200731460.8750@uplift.swm.pp.se> <CAOS+5GEcpOV6dkkGYHjkA3ah88MXqyJ0AFS7T--qaCc-Z1-=uw@mail.gmail.com>
 <CAOS+5GHLFcbN=ROQ_YBLFYzw6iu+TZ4RcZvHdDbE+V3pqS_rCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHLFcbN=ROQ_YBLFYzw6iu+TZ4RcZvHdDbE+V3pqS_rCw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 20 Sep 2015, Another Sillyname wrote:

> Thanks
>
> Would you.....
>
> mdadm --assemble --force --scan
>
> or
>
> mdadm --assemble --force /dev/mdxx /dev/sd[c-i]1

This last one is what I use myself.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
