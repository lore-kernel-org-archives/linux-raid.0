From: David Brown <david.brown@hesbynett.no>
Subject: Re: USB-to-SATA and RAID
Date: Thu, 25 Jan 2018 09:05:05 +0100
Message-ID: <5A698FB1.4090702@hesbynett.no>
References: <20180123201614.GI23784@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180123201614.GI23784@otheros>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TGludXMgTMO8c3Npbmc=?= <linus.luessing@c0d3.blue>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/01/18 21:16, Linus Lüssing wrote:
> Hi,
> 
> By chance I found this statement in the Linux RAID Wiki:
> 
> "Do NOT use [USB devices] as part of your array. They have
>  a timeout/disconnect mechanism which interacts very
>  badly with the raid code." [0]
> 
> Could someone elaborate further on this? Does "interacts very
> badly" mean that there will be potential data loss / data
> corruption? Or does "very badly" just mean short, temporary
> performance issues / lags upon a disk failure?

I would expect that the majority of USB disk issues can be avoided by
due care and attention.

USB buses are rarely reset or re-initialised without provocation.  The
cause is generally flaky hardware on the bus, plugging or unplugging
devices, devices that sleep waking up, sudden changes in power
requirements of devices, and other physical events.

When using USB disks, I'd give the following advice:

1. Connect directly to a USB port on the computer, not via a hub.  That
way you don't have other devices on the same bus that could cause trouble.

2. Avoid plugging other hardware in and out of the other USB buses, and
certainly avoid it on the bus with the disk.  Keep the bus physically
stable.

3. Avoid having high power devices on USB, like DVD burners.  If the
disk has an optional external power supply, use it.

4. Ensure your USB disks are cooled appropriately.  Some USB disk
enclosures are very tight around the disk and can overheat.
Freestanding USB-to-SATA converters where you plug the bare disk in
directly can be good (but beware of dust if you are leaving them for a
while).

5. Use good cables and avoid plugging and unplugging things too much, to
limit the risk of broken wires and worn contacts.

6. Don't rely on the USB drive - use it as an extra.  They are great for
taking extra backups, and to provide additional redundancy during risky
operations (such as to add an asymmetric second parity drive to a raid5
set before replacing the raid5 disks with bigger devices).

7. Don't use "memory stick" USB drives for raid - these have very
limited write lifetimes and are easily corrupted.

8. And for the love of $DEITY, /don't/ have USB drives connected by
cables where you will trip over them and throw the drive across the
room.  (As Yoda says, good judgement comes from experience.  Experience
comes from bad judgement!)



> 
> Regards, Linus
> 
> [0]: https://raid.wiki.kernel.org/index.php/Choosing_your_hardware,_and_what_is_a_device%3F#USB_devices

