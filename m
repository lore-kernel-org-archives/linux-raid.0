From: Phil Turmel <philip@turmel.org>
Subject: Re: Help needed: Recovering a failed RAID-6 array
Date: Thu, 14 Dec 2017 14:10:11 -0500
Message-ID: <87748829-ae83-a9de-108c-d1c462eec8bc@turmel.org>
References: <ab609d12-801c-f283-19e0-b68a72b79238@3de.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ab609d12-801c-f283-19e0-b68a72b79238@3de.com.pl>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Ryszard Harasimowicz <rharasimowicz@3de.com.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Ryszard,

On 12/14/2017 01:30 PM, Ryszard Harasimowicz wrote:
> A friend of mine has got a serious problem after replacing a failed disk
> in a RAID-6 array.

[trim /]

> When the Raid Device number 9 has failed the system was shutdown and the
> drive was replaced.

The event counts are surprising considering the short time between first
failure and the other two devices dropping out.  Those two *think* they
are OK, and they both show the other still running.  So, a common reason
took them out.

The event counts might mean the OMV kit is trying to assemble this over
and over again.  You'll have to disable that.

> Then the system was started - but the array did not rebuild (as was
> expected). It showed up as FAILED with 3 drives marked as "removed".
> 
> The current state is:

[trim /]

> What would be the safest strategy to try to recover data from this
> array? Is it still possible?

First, stop the array:

mdadm --stop /dev/md127

Then, assemble the array with --force to get past the bad event counts:

mdadm -Afv /dev/mdX /dev/sd[abcdghijklmnop]

If that succeeds, run fsck on the filesystem(s) and then backup any
irreplaceable files.  If it fails, paste the output here.

> I send attached the status report for all the drives in the array
> (except for the replaced one).

It would be good to know *why* this happened.  Consider supplying
"smartctl -iA -l scterc" reports.  I suspect your distro's boot time
limits are too short, or some device didn't get recognized in the initramfs.

The output of lsdrv[1] would help identifying odd circumstances.

Phil

[1] https://github.com/pturmel/lsdrv

