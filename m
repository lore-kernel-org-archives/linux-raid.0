From: Ron Leach <ronleach@tesco.net>
Subject: Re: If separate md for /boot, OS, and /srv, must 'create' on disks
 with 3 partns?
Date: Mon, 20 Jan 2014 19:07:40 +0000
Message-ID: <52DD73FC.7000801@tesco.net>
References: <52DC1BED.7070901@tesco.net> <52DC39A7.5020506@turmel.org> <52DD5471.4070809@tesco.net> <52DD6B20.5030906@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DD6B20.5030906@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/01/2014 18:29, Phil Turmel wrote:
>
> Let me clarify:  /dev/md0 should be a v0.90 or v1.0 raid1 for /boot, no LVM.
 >
 > /dev/md1 is an LVM PV for the OS.


Ok.  That means I need physical partitions for those, on each of the 
drives.

Since I am using 3TB drives, I'll need to use a GPT which, if I 
understand correctly, requires to reveal a dummy 'partition' to make 
the BIOS think there is a boot sector thingy there.

So I'm assuming to pre-partition the physical devices this way:

/dev/sd[x]1 - 64k (? I'm checking the docs) empty, for BIOS to see
/dev/sd[x]2 - 128 MB /boot v0.90/v1.0 RAID1, /dev/md0
/dev/sd[x]3 - remainder ~3 TB for LVM, v1.2 RAID1, /dev/md1

and then make the two RAID1s, and then create the LVM.

>
>
> Having root in an LVM allows strange things like relocating and/or
> resizing it on the fly.  Particularly handy if physical access is difficult.
>

Yes, it was that potential aspect that set me deciding to try your 
approach.  Functional demands on our systems keep changing.

Much appreciated, Ron
