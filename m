From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Auto Rebuild on hot-plug
Date: Thu, 25 Mar 2010 14:10:05 +0000
Message-ID: <4BAB6EBD.2030503@anonymous.org.uk>
References: <20100325113543.0e2124c5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100325113543.0e2124c5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On 25/03/2010 00:35, Neil Brown wrote:
> Greetings.
>  I find myself in the middle of two separate off-list conversations on the
>  same topic and it has reached the point where I think the conversations
>  really need to be unite and brought on-list.
> 
>  So here is my current understanding and thoughts.
> 
>  The topic is about making rebuild after a failure easier.  It strikes me as
>  particularly relevant after the link  Bill Davidsen recently forwards to the
>  list:
> 
>        http://blogs.techrepublic.com.com/opensource/?p=1368
> 
>  The most significant thing I got from this was a complain in the comments
>  that managing md raid was too complex and hence error-prone.
> 
>  I see the issue as breaking down in to two parts.
>   1/ When a device is hot plugged into the system, is md allowed to use it as
>      a spare for recovery?
>   2/ If md has a spare device, what set of arrays can it be used in if needed.
> 
>  A typical hot plug event will need to address both of these questions in
>  turn before recovery actually starts.
> 
>  Part 1.
> 
>   A newly hotplugged device may have metadata for RAID (0.90, 1.x, IMSM, DDF,
>   other vendor metadata) or LVM or a filesystem.  It might have a partition
>   table which could be subordinate to or super-ordinate to other metadata.
>   (i.e. RAID in partitions, or partitions in RAID).  The metadata may or may
>   not be stale.  It may or may not match - either strongly or weakly -
>   metadata on devices in currently active arrays.

Or indeed it may have no metadata at all - it may be a fresh disc. I 
didn't see that you stated this specifically at any point, though it was 
there by implication, so I will: you're going to have to pick up hotplug 
events for bare drives, which presumably means you'll also get events 
for CD-ROM drives, USB sticks, printers with media card slots in them etc.

>   A newly hotplugged device also has a "path" which we can see
>   in /dev/disk/by-path.  This is somehow indicative of a physical location.
>   This path may be the same as the path of a device which was recently
>   removed.  It might be one of a set of paths which make up a "RAID chassis".
>   It might be one of a set of paths one which we happen to find other RAID
>   arrays.

Indeed, I would like to be able to declare any 
/dev/disk/by-path/pci-0000:00:1f.2-scsi-[0-4] to be suitable candidates 
for hot-plugging, because those are the 5 motherboard SATA ports I've 
hooked into my hot-swap chassis.

As an aside, I just tried yanking and replugging one of my drives, on 
CentOS 5.4, and it successfully went away and came back again, but 
wasn't automatically re-added, even though the metadata etc was all there.

>   Some how from all of that information we need to decide if md can use the
>   device without asking, or possibly with a simple yes/no question, and we
>   need to decide what to actually do with the device.
> 
>   Options for what to do with the device include:
>     - write an MBR and partition table, then do something as below with
>       each partition

Definitely want this for bare drives. In my case I'd like the MBR and 
first 62 sectors copied from one of the live drives, or a copy saved for 
the purpose, so the disc can be bootable.

My concern is that this is surely outwith the regular scope of 
mdadm/mdmon, as is handling bare drives/CD-ROMs/USB sticks. Do we need 
another mdadm companion rather than an addition?

>     - include the device (or partition) in an array that it was previously
>       part of, but from which it was removed

Definitely, just so I can pull a drive and plug it in again and point 
and say ooh, everything's up and running again, to demonstrate how cool 
Linux md is. I imagine some distros' udev/hotplug rules do this already, 
almost by default where they assemble arrays incrementally.

>     - include the device or partition as a spare in a native-metadata array.

I think in my situation I'd quite like the first partition, type fd 
metadata 0.90 RAID-1 mounted as /boot, added as an active mirror not a 
spare, again so that if this new drive appears as sda at the next power 
cycle, the system will boot.

The second partition, a RAID-5 with LVM on it, could be added as a 
spare, because it would then automatically be rebuilt onto if the array 
was degraded.

>  Part 2.
[...]

I'm afraid I have nothing to add here, it all sounds good.

Cheers,

John.

