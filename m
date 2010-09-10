From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Virtual unplug (was Re: [PATCH 26/30] ext4: do not send discards
 as barriers)
Date: Fri, 10 Sep 2010 17:59:29 +0100
Message-ID: <4C8A63F1.4060706@anonymous.org.uk>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com> <4C7CB936.8010509@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C7CB936.8010509@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/08/2010 09:11, Tejun Heo wrote:
[...]
> $ echo 1>  /sys/block/sdX/device/delete
> $ echo - - ->  /sys/class/scsi_host/hostX/scan
>
> should do the trick.

Handy that, I just used it to pretend unplug and replug a USB external 
drive after I'd changed the partition table and formatted them, to get 
the new partitions to appear in /dev/disk/by-uuid/

Cheers,

John.
