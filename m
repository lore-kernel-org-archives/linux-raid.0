From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: getting a linux boot loader (preferably grub) installed on an
 intel imsm raid
Date: Thu, 19 Aug 2010 14:40:51 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D504666ADCD3@azsmsx504.amr.corp.intel.com>
References: <4C6CB965.7000905@gmail.com>
 <D010E79907AF0D4E90B603DE907837D504666ADB3D@azsmsx504.amr.corp.intel.com>
 <4C6D78BF.1060603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6D78BF.1060603@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "K. Posern" <quickhelp@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: K. Posern [mailto:quickhelp@gmail.com]
> Sent: Thursday, August 19, 2010 11:33 AM
> To: Jiang, Dave
> Cc: linux-raid@vger.kernel.org
> Subject: Re: getting a linux boot loader (preferably grub) installed on
> an intel imsm raid
> I personally use Gentoo --> no fancy GUI/install-scripts, but
> everything
> manual :)
> 
> As I said: Ubuntu has a device-mapper based binary package of grub2
> that
> seems to install itsself in a way that allows to boot from an Intel
> OROM
> RAID (fakeraid). But that doesn't help me with Gentoo.
> 
> But I am really stuck alone, so I am willing to throw a Fedora on my
> machine if in exchange I would get the grub commands to make grub boot
> my intel RAID-0 :)

Well theoretically the OROM would present the RAID volume to the bootloader as a disk that it can read from. So if you mark your RAID volume for booting in BIOS, it should be able to pick up the bootloader from there right? Are you not able to install to /dev/md127 or whatever device node your RAID volume is on?

Also technically the imsm RAID is not fakeraid because it uses MDRAID instead of special driver to "fake" RAID in Linux. It's just Linux software RAID with OROM support. 
 
>  > Just FYI Intel is moving forward with MDRAID.
> Nice :)
> 
> Do you happen to know if mdadm just integrated (parts of) the dmraid
> code?
> Because that's one of the many /rumors/ I picked up ;)
> (and that I would like to put to an end ;)

I have seen some patches posted on this mailing list in regards to putting in DMRAID support so MDRAID can handle DMRAID arrays. I believe it's still work in progress. Neil can probably tell you more about that. 
