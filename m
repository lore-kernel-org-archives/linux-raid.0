From: Travis Williams <travis@euppc.com>
Subject: (unknown)
Date: Wed, 26 Nov 2014 12:38:44 -0600
Message-ID: <CABGuBc=AJZzxR9W7frK_bdhaq24p1evsOBAdB1Otb4M2hbfqWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I feel as though I must be missing something that I have had no luck
finding all morning.

When setting up arrays with spares in a spare-group, I'm having no
luck finding a way to get that information from mdadm or mdstat. This
becomes an issue when trying to write out configs and the like, or
simply trying to get a feel for how arrays are setup on a system.

Many tutorials/documentation/etc etc list using `mdadm --scan --detail
>> /etc/mdadm/mdadm.conf` as a way to write out the running config for
initialization at reboot.  There is never any of the spare-group
information listed in that output. Is there another way to see what
spare-group is included in a currently running array?

It also isn't listed in `mdadm --scan`, or by `cat /proc/mdstat`

I've primarily noticed this with Debian 7, with mdadm v3.2.5 - 18th
May 2012. kernel 3.2.0-4.

When I modify the mdadm.conf myself and add the 'spare-group' setting
myself, the arrays work as expected, but I haven't been able to find a
way to KNOW that they are currently running that way without failing
drives out to see. This nearly burned me after a restart in one
instance that I caught out of dumb luck before anything of value was
lost.

Thanks,

-Travis
