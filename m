From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when stopping
Date: Wed, 17 Feb 2016 08:06:28 -0500
Message-ID: <wrfj1t8ba3l7.fsf@redhat.com>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
	<1455633877-4813-3-git-send-email-sebastian.riemer@profitbricks.com>
	<wrfjio1oeemz.fsf@redhat.com> <56C36487.3060201@profitbricks.com>
	<56C36D20.6030001@suse.de> <wrfja8n0bi8n.fsf@redhat.com>
	<8737sstmbh.fsf@notabene.neil.brown.name> <56C41B3A.90902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C41B3A.90902@suse.de> (Hannes Reinecke's message of "Wed, 17
	Feb 2016 08:03:22 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: NeilBrown <neilb@suse.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

Hannes Reinecke <hare@suse.de> writes:
> On 02/16/2016 09:46 PM, NeilBrown wrote:
>> On Wed, Feb 17 2016, Jes Sorensen wrote:
>>> 
>>> I am totally fine with this, however we should make mdadm
>>> fail if run against a pre-2.6.28 kernel then.
>>> 
>>> Cheers, Jes
>> 
>> I would suggest protecting the
>> 
>> if (fd >= 0) ioctl(fd, BLKRRPART, 0); if (mdi) 
>> sysfs_uevent(mdi, "change");
>> 
>> code with
>> 
>> if (get_linux_version() < 2006028)
>> 
>> That should be completely safe - 2.6.28 and later do this (if
>> needed).
>> 
> +1.
>
> Yes, this is the best solution.

Sebastian indicates it only works if the kernel patch he submitted is
applied too - should we tweak the mdadm version check to match the next
upstream kernel, or stick with it as is here?

Jes

