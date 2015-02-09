From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid md126, md127 problem after reboot, howto fix?
Date: Mon, 09 Feb 2015 10:22:50 +0000
Message-ID: <54D88A7A.4000207@youngman.org.uk>
References: <54D7B317.5010809@gmail.com> <54D883FA.8080401@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D883FA.8080401@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Marc Widmer <metafor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/15 09:55, Sebastian Parschauer wrote:
>> > Any ideas what i should do? Howto put the raid back together, possibly in
>> > live mode, without rebooting in rescue mode and risk long downtime?
> Just stop all arrays which aren't in use at the moment and assemble them
> manually. If they are already running degraded, then add the now
> unassociated disks to their respective running arrays.
> 
> $ mdadm --stop /dev/md126
> $ mdadm --stop /dev/md127
> $ mdadm /dev/md1 --add /dev/sda1
> $ mdadm /dev/md2 --add /dev/sda2
> 
> This could require some syncing but then everything should be normal again.

This isn't just a Debian/Ubuntu problem - I run gentoo.

And isn't there a re-add option? That will hopefully just require a
recovery rather than a total resync.

Cheers,
Wol
