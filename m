From: Markus Doits <markus.doits@googlemail.com>
Subject: Re: Raid10 disc-activity every five seconds
Date: Tue, 24 Nov 2009 18:48:02 +0100
Message-ID: <4B0C1C52.6060203@googlemail.com>
References: <4B0BBDB4.1010403@googlemail.com> <4B0BBF89.6040400@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B0BBF89.6040400@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/24/2009 12:12 PM, John Robinson wrote:
> On 24/11/2009 11:04, Markus Doits wrote:
>> just wanted to silency my pc by reducing disk-activity. what bothers me
>> is: my disk "click" about every five seconds.
> [...]
> 
> Try mounting the filesystem that's on md2 with the noatime option.
> 
> Cheers,
> 
> John.
> 

thanks for your reply, but they are already:

/dev/mapper/eltarun-root on / type ext4 (rw,noatime,errors=remount-ro)
/dev/mapper/eltarun-debian32 on /mnt/debian32 type ext4 (rw,noatime)
/dev/mapper/eltarun-recordings on /mnt/recordings type ext4 (rw,noatime)
/dev/mapper/eltarun-home on /home type ext4 (rw,noatime)

this gave me another idea: besides the raid-volumes differ in their type
(raid1/raid10), the raid10-volume is actually a lvm2-volume.

but since the process "[md2_raid10]" is triggering the activity, for me
it still looks like the raid is the cause. any other ideas? any way to
check why it is writing to the device?
