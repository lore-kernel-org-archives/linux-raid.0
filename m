From: Pierre Beck <mail@pierre-beck.de>
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to
 lose this disk controller?
Date: Tue, 02 Oct 2012 01:54:47 +0200
Message-ID: <506A2D25.2040904@pierre-beck.de>
References: <87mx0lsv4d.fsf@spindle.srvr.nix> <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> <87r4pslpau.fsf@spindle.srvr.nix> <506A0BFB.60606@pierre-beck.de> <2A7CFE69-08F3-4C53-928C-A94907027CAC@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2A7CFE69-08F3-4C53-928C-A94907027CAC@colorremedies.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Yes. When in degraded mode, timeout should be raised to five minutes or 
so. When in clean mode, timeout should be a tunable in milliseconds. 
Commercial RAIDs offer timeouts in ranges like 200ms - 2s. Plus a disk 
which was kicked that way should be scanned for and re-added if 
possible. With write-intent bitmaps, that would make RAIDs with aging 
disks or cables much more solid.

Also, non-degraded mode: Skip loop resets. Skip all resets actually, if 
possible. Just kick the disk. Degraded mode: Perform loop resets as it 
is now. A hung-up controller would then cause an array to degrade, but 
won't hang indefinitely. Granted, always doing loop resets keeps the 
array non-degraded, but a crashed controller is rare whilst failing 
disks are common.

linux-scsi and linux-raid should talk about this one day to make it 
happen. Requires a bit of interfacing between the layers.

On 02.10.2012 00:53, Chris Murphy wrote:
> On Oct 1, 2012, at 3:33 PM, Pierre Beck wrote:
>> It's particularly annoying when in RAID and the disk could've simply been kicked within few seconds. Something that needs improvement IMHO.
> Except that while this helps with faster recovery, you're now degraded. You wouldn't want this "fast recovery" behavior if you're at your critical number of disks remaining or you lose the array upon a few seconds worth of subsequent problems. So we kinda need context specific behavior.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
