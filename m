From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when
 stopping
Date: Tue, 16 Feb 2016 17:58:00 +0100
Message-ID: <56C35518.6080709@profitbricks.com>
References: <56C3447A.3050504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C3447A.3050504@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16.02.2016 16:47, Hannes Reinecke wrote:
> Hi Sebastian,
> 
> while it's true in general that a 'change' event should not be sent
> when a device is being removed or deleted, sending a 'remove' event
> from userspace is most definitely wrong, too.
> 'remove' events should be generated from the kernel whenever a
> device disappears from sysfs; it should never be generated from
> userspace (as the device will still be present in sysfs).

Hi Hannes,

thanks for your comment! Only few people actually stop md devices
without rebooting. As a hotfix for running systems it is definitely the
best solution for us at PB to do it in mdadm. Mdadm knows in this
situation that stopping worked.

But I'm also fine with dropping the support for kernels prior to 2.6.28
and the event sending in mdadm completely for the mainline. Sending the
kernel patch to linux-stable is kind of useless if mdadm still sends the
change event.
So your vote seems to be dropping the udev event sending in mdadm and
going for the kernel change.

I'll wait for other comments or votes for the preferred solution.

Cheers,
Sebastian
