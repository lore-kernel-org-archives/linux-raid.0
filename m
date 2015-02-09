From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: raid md126, md127 problem after reboot, howto fix?
Date: Mon, 09 Feb 2015 11:33:53 +0100
Message-ID: <54D88D11.4040207@profitbricks.com>
References: <54D7B317.5010809@gmail.com> <54D883FA.8080401@profitbricks.com> <54D88A7A.4000207@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D88A7A.4000207@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Marc Widmer <metafor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09.02.2015 11:22, Wols Lists wrote:
> On 09/02/15 09:55, Sebastian Parschauer wrote:
>>>> Any ideas what i should do? Howto put the raid back together, possibly in
>>>> live mode, without rebooting in rescue mode and risk long downtime?
>> Just stop all arrays which aren't in use at the moment and assemble them
>> manually. If they are already running degraded, then add the now
>> unassociated disks to their respective running arrays.
>>
>> $ mdadm --stop /dev/md126
>> $ mdadm --stop /dev/md127
>> $ mdadm /dev/md1 --add /dev/sda1
>> $ mdadm /dev/md2 --add /dev/sda2
>>
>> This could require some syncing but then everything should be normal again.
> 
> This isn't just a Debian/Ubuntu problem - I run gentoo.

Okay.

> And isn't there a re-add option? That will hopefully just require a
> recovery rather than a total resync.

Yes, sure, --re-add should be tried first. If it doesn't work, then the
--add option will definitely work.

Cheers,
Sebastian


