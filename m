From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: How to get md to attempt to scrub blocks in its bad blocks list
Date: Thu, 18 Aug 2016 02:05:44 +1000
Message-ID: <7a7286bb-dc33-3431-8e7a-90a434973239@websitemanagers.com.au>
References: <b6c01e91-9786-9705-a452-253794f65bc6@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b6c01e91-9786-9705-a452-253794f65bc6@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 18/08/2016 00:59, Tim Small wrote:
> Hello,
>
> I have had a look around at the other md arrays I manage following the
> problems I've recently written about...
>
> I have a machine with a single local SATA disk (an old laptop which only
> has capacity for a single disk, and is used for backups), and a remote
> iSCSI disk.  Both devices are members of a RAID1, with the remote drive
> having the write-mostly flag set.
>
> The iSCSI device had a write error during a resync, due to a transient
> memory allocation failure on the remote machine.
>
> I've cleared the write_error and want_replacement flags for the device
> according to the kernel md docs, but can't see how to provoke md into
> attempting to scrub the bad blocks?
>
> Also in general, are there any mechanisms to get md to retry for longer?
>   I've done this so-far:
>
> ISCSIDISK=$(basename `readlink
> /dev/disk/by-id/wwn-0x60014059ba55d40d7fc416d928211f5b`)
> echo 600 > /sys/block/${ISCSIDISK}/device/timeout
>
> in an attempt to work-around transient write errors due to memory
> allocation failures, target machine reboots, network errors etc.
>
> Should I be doing anything else (e.g. can I configure retries for failed
> writes)?
>
In the past I've done this with NBD and eNBD (Network Block Device and 
Enhanced...), both worked really well. Any remote error/problem meant 
that the remote disk was failed, and fixing the remote issue, and then 
re-add to the array, (with the bitmap enabled) meant a quick resync.

More recently, I use DRBD for the same thing, it seems to be a lot more 
reliable, automatic, etc (8.4.x version, the 9.0.x versions is still a 
bit experimental in my experience).

So, I can't directly answer your questions, other than to suggest you 
consider looking at other technologies that are more directly designed 
to do that.

Regards,
Adam
