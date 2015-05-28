From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Which physical device failed?
Date: Thu, 28 May 2015 10:03:07 +0100
Message-ID: <BLU436-SMTP130425AB27C6A18A48E9D3D98CA0@phx.gbl>
References: <5565B2BB.5090701@gmail.com>	<5565B41B.8040104@aei.mpg.de>
	 <20150527172701.1090e525@natsu> <5565C3AA.7020809@turmel.org>
	 <BLU436-SMTP2403ED333F23D8DB23296C398CB0@phx.gbl>
	 <55660F37.8000402@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55660F37.8000402@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roman Mamedov <rm@romanrm.net>, Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2015-05-27 at 14:38 -0400, Phil Turmel wrote:
> Hi Jonathan,
> 
> On 05/27/2015 02:16 PM, Wilson, Jonathan wrote:
> > On Wed, 2015-05-27 at 09:16 -0400, Phil Turmel wrote:
> >> This is one of the reasons I wrote lsdrv [1], especially after I noticed
> >> that the port sequence it reports is stable for the various ports on
> >> every mobo  and sata expansion card I've handled.  Per controller, at least.
> > 
> > Interesting that you should say that as on my z97 board if I do a power
> > off, power on, the drives do indeed stay numbered to the sata ports...
> > however if I do a "restart" sometimes, very rarely, the drives are
> > listed with different sdX designations. It may be a quirk of either the
> > efi, linux, or the fact the drives are not, I believe, turned off during
> > a restart which may impact on designation. I didn't investigate the whys
> > as I just noticed that two drives had swapped in two arrays (sdb moved
> > from a raid10 into the raid6 and that sdc moved from the raid6 into the
> > raid10) which scared the heck out of me until I realised that it was
> > just the sdX that had changed not the drives so for one minute I was
> > expecting massive problems to ensue.
> 
> I didn't say the names are consistent--in fact, your experience is
> entirely normal with modern kernel's device discovery.  The names come
> out the same for many people by chance (timing, interrupts, whatever).
> But a new kernel might have slight differences, and then the names change.

My mistake I misinterpreted what you said.

> 
> My comment was referring to the SCSI LUNs "N:P:Q:R" that appear under
> each controller in lsdrv.  These correspond to the hostN/targetP:Q:R
> folders in sysfs.  P:Q:R appears to reliably correspond to physical
> ports. Sometimes with phantom ports, but reliably so.  Which is why
> lsdrv shows them in order, even if empty.  For the controllers I've
> played with so far, that is.  Consider labeling your cables with the
> mobo or adapter's silkscreened port ID and the corresponding P:Q:R string.

I did something similar, "card/port" A-[1-6] (main cpu sata, port)
B-[1-2] (marvel on board, port) C-[1-4] (jbod marvel card, port).

The main reason was that unlike older boards for some strange reason
(circuit paths I guess) the ordering of the physical sata port sockets
bares no relation to the sequence.

> 
> Anyways, MD uses the superblock metadata to make sure array members are
> properly assembled regardless what name they have at any moment.  LVM
> does so as well.  The mdadm --detail report that shows kernel names
> cannot be trusted across boots or between kernel versions.
> 
> If you are using /dev/sdX names in fstab or mdadm.conf, you may be
> surprised by a boot failure at some point.

Luckily I have always used GUIDs, but after 4 OS upgrades and many years
of use had never once seen devices not follow chip/port when providing
sdX names so it came as quite a shock even though I knew sdX names can
not be trusted to remain consistent. The only time I had seen them
shift/swap was when say a usb device grabbed sda and the rest shifted 1
letter up.

> 
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


