From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fwd: Failed Raid6 Array.....want some guidance before attempting
 restart
Date: Mon, 21 Sep 2015 09:12:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1509210909380.8750@uplift.swm.pp.se>
References: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com> <alpine.DEB.2.02.1509200731460.8750@uplift.swm.pp.se> <CAOS+5GEcpOV6dkkGYHjkA3ah88MXqyJ0AFS7T--qaCc-Z1-=uw@mail.gmail.com> <CAOS+5GHLFcbN=ROQ_YBLFYzw6iu+TZ4RcZvHdDbE+V3pqS_rCw@mail.gmail.com>
 <alpine.DEB.2.02.1509201153490.8750@uplift.swm.pp.se> <CAOS+5GHf1N6s9bsrveesuhm6cnxRVnb6XSjXoHoLVU7Np-i-Bw@mail.gmail.com> <CAOS+5GHtJAYdHEHnvb+Akfc+jkh5es8cb8z50YQwB23rnk+_Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHtJAYdHEHnvb+Akfc+jkh5es8cb8z50YQwB23rnk+_Sw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 21 Sep 2015, Another Sillyname wrote:

> Thanks for the help and advice....and most of all the confirmation my 
> approach was the correct one.

It would be helpful if you posted the dmesg output from what you did. So 
while this approach is ok, so you stated, you're vulnerable to read errors 
on the remaining drives.

It's possible a newer mdadm would have --assemble --force in the two last 
drives as well. You have an internal bitmap, which should have meant that 
you shouldn't have had to do a full resync.

So what happened to you isn't optimal and it would be helpful to 
understand what kernel version, mdadm version you used, and what the 
output from your steps were.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
