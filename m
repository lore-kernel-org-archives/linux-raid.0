From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: Failed Raid6 Array.....want some guidance before attempting restart
Date: Mon, 21 Sep 2015 08:57:13 +0100
Message-ID: <CAOS+5GE-m7kcpLmUovJGsk5_C-7kLpPc4XeHy7Hx4n-_Xf320g@mail.gmail.com>
References: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com>
	<alpine.DEB.2.02.1509200731460.8750@uplift.swm.pp.se>
	<CAOS+5GEcpOV6dkkGYHjkA3ah88MXqyJ0AFS7T--qaCc-Z1-=uw@mail.gmail.com>
	<CAOS+5GHLFcbN=ROQ_YBLFYzw6iu+TZ4RcZvHdDbE+V3pqS_rCw@mail.gmail.com>
	<alpine.DEB.2.02.1509201153490.8750@uplift.swm.pp.se>
	<CAOS+5GHf1N6s9bsrveesuhm6cnxRVnb6XSjXoHoLVU7Np-i-Bw@mail.gmail.com>
	<CAOS+5GHtJAYdHEHnvb+Akfc+jkh5es8cb8z50YQwB23rnk+_Sw@mail.gmail.com>
	<alpine.DEB.2.02.1509210909380.8750@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1509210909380.8750@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kernel....

Linux arandomserver1 3.12.10-300.fc20.x86_64 #1 SMP Thu Feb 6 22:11:48
UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

mdadm

mdadm-3.3-4.fc20.x86_64

I'll post the dmesg once the rebuild has finished.

This particular server is due to be upgraded/rebuilt next month (which
is why the backups are currently happening), generally I rebuild the
server on about a 2 year cycle for upgrades and minimise incremental
upgrades, mainly because experience has taught me that an up, stable,
un-interfered with server suffers less failures (hardware and
software) then one being rebooted every few months.

In 15+ years this is honestly the first time I can remember a server I
owned having a failure that happened during normal run...rather then
during an upgrade or reboot.

 Once again thanks for the help.



On 21 September 2015 at 08:12, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Mon, 21 Sep 2015, Another Sillyname wrote:
>
>> Thanks for the help and advice....and most of all the confirmation my
>> approach was the correct one.
>
>
> It would be helpful if you posted the dmesg output from what you did. So
> while this approach is ok, so you stated, you're vulnerable to read errors
> on the remaining drives.
>
> It's possible a newer mdadm would have --assemble --force in the two last
> drives as well. You have an internal bitmap, which should have meant that
> you shouldn't have had to do a full resync.
>
> So what happened to you isn't optimal and it would be helpful to understand
> what kernel version, mdadm version you used, and what the output from your
> steps were.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
