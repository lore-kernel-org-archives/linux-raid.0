From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Partitions not recognized when auto-assembling array in initramfs
Date: Tue, 28 Dec 2010 04:35:41 +0000
Message-ID: <4D19691D.5010707@anonymous.org.uk>
References: <201012271618.09209.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012271618.09209.laurent.pinchart@ideasonboard.com>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/12/2010 15:18, Laurent Pinchart wrote:
[...]
> livecd ~ # mdadm --assemble --scan
> mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> mdadm: Started /dev/md/vol0_0 with 2 devices
[...]
> livecd ~ # mdadm -E --scan
> ARRAY metadata=imsm UUID=480da1d0:8150f280:7dd8425d:bec99c46
> ARRAY /dev/md/vol0 container=480da1d0:8150f280:7dd8425d:bec99c46 member=0
> UUID=17e28225:34f7c425:eb78aece:05c29a40
>
> livecd ~ # mdadm --assemble --scan
> mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> mdadm: Started /dev/md/vol0 with 2 devices
[...]
> Still good so far. The /dev/md/vol0_0 device is now called /dev/md/vol0.
[...]
> If I remove the /etc/mdadm.conf file from the initramfs image, the volume is
> detected as vol0_0 instead of vol0 and the partitions are correctly detected.
>
> I don't understand what's going on there, and how I could fix it. Help would
> be greatly appreciated.

I don't quite get it either, but there's something funny going on with 
the device name. I don't know if you've a choice in the name or what, 
but do things run any more smoothly if you edit the mdadm.conf to have 
ARRAY /dev/md/vol0_0 container= etc? If so, and you don't like the _0, 
you may be able to rename the array with --update=name when assembling 
it. Disclaimer: I don't know much about imsm so I don't really know 
about the device names and whether they can be selected or renamed.

Cheers,

John.

