From: Another Sillyname <anothersname@googlemail.com>
Subject: Fwd: Failed Raid6 Array.....want some guidance before attempting restart
Date: Sun, 20 Sep 2015 10:19:52 +0100
Message-ID: <CAOS+5GHLFcbN=ROQ_YBLFYzw6iu+TZ4RcZvHdDbE+V3pqS_rCw@mail.gmail.com>
References: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com>
	<alpine.DEB.2.02.1509200731460.8750@uplift.swm.pp.se>
	<CAOS+5GEcpOV6dkkGYHjkA3ah88MXqyJ0AFS7T--qaCc-Z1-=uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GEcpOV6dkkGYHjkA3ah88MXqyJ0AFS7T--qaCc-Z1-=uw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks

Would you.....

mdadm --assemble --force --scan

or

mdadm --assemble --force /dev/mdxx /dev/sd[c-i]1

or

another variant of the mdadm command?

On 20 September 2015 at 06:34, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Sat, 19 Sep 2015, Another Sillyname wrote:
>
>> I don't just want to try a forced assemble until someone casts their eye
>> over this (and anything else wanted) and lets me know the best way to
>> proceed.....
>
>
> The event counts are off by just a little bit, so if I were in your position
> I would stop the array and then --assemble --force with all the devices. If
> this doesn't work (because some of them are marked as failed), I would
> compile latest mdadm version from the git repository, and then try
> --assemble --force with that mdadm version instead.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
