From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 10 Issue - Booting in case raid failed
Date: Fri, 06 Mar 2015 15:12:37 -0500
Message-ID: <54FA0A35.8040304@turmel.org>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de> <54F8B792.9060206@turmel.org> <1315687872.8638.1425636591443.JavaMail.open-xchange@app04.ox.hosteurope.de> <322760937.22899.1425668800663.JavaMail.open-xchange@app04.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <322760937.22899.1425668800663.JavaMail.open-xchange@app04.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2015 02:06 PM, Stefan Lamby wrote:
> Hi list.
> 
> If everything will work out OK, I will end up with an raid 10 array with 4
> devices.
> 
> My partition design and layout structure will be found at the end, if needed.
> 
> There are a few questions left for me in case I have to boot with a failed disk:
> 
> 1) As you might have seen from the partition design, only partition sda1 has the
> boot flag set. As far as I guess, the ubuntu installer was using grub-install
> only for sda. I am kind of afraid what will happen, in case sda will fail in the
> future. Will it be a good idea to grub-install to all the other devices also?

Yes, sort of.

> 2) What about the boot flag, if I need to grub-install the other devices also?
> Should it be O or 1? Do I have to leave it set to false and in case things go
> wrong boot from a live cd and set it to on to boot from another device?

Set to true.

But the "sort of" comes from your reliance on grub support for MD raid,
and having the appropriate mirrors containing the boot folder.  You've
left enough space before your first partition (48g) to easily hold a
plain raid1 x4 boot partition and a raid6 root partition (use a small
chunk size for that).  Then your system could boot with any two drives
missing, and let you know what's possible with the large raid10.

Also note that this kind of boot redundancy only helps if the bad drive
is entirely missing at boot time.  If you really need boot redundancy,
you have fewer choices:  BIOS fakeraid, or hardware raid with a BIOS
extension, or EFI boot with a monolithic kernel/initramfs on each device.

HTH,

Phil
