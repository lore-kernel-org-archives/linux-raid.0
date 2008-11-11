From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Swapping a disk in a raid5 array
Date: Tue, 11 Nov 2008 22:49:21 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0811112247050.10993@uplift.swm.pp.se>
References: <994670.29528.qm@web30807.mail.mud.yahoo.com> <1226438490.4765.58.camel@firewall.xsintricity.com> <565033.56273.qm@web30806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <565033.56273.qm@web30806.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 Nov 2008, Mike Myers wrote:

> Thanks.  I hadn't heard of the "check" technique.  Is that described somewhere?  It should be in the software raid howto.

<http://linux-raid.osdl.org/index.php/RAID_Administration>

Debian/Ubuntu has this:

:/etc/cron.d$ grep check mdadm
# cron.d/mdadm -- schedules periodic redundancy checks of MD devices
57 0 * * 0 root [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le 7 
] && /usr/share/mdadm/checkarray --cron --all --quiet

This will do the same thing once a month.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
