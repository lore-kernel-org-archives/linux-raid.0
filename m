From: Derek Piper <derek.piper@gmail.com>
Subject: Re: now on to tuning....
Date: Thu, 10 Mar 2005 14:13:40 -0500
Message-ID: <eaa6dfe05031011135b430688@mail.gmail.com>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E4355@NZURC900PEX1.ubsgs.ubsgroup.net>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E4355@NZURC900PEX1.ubsgs.ubsgroup.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm..  for me:

> smartctl -A -d ata /dev/sda

On my work machine with Debian Sarge:
----------------------------------------------------------------------------
smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)

A mandatory SMART command failed: exiting. To continue, add one or
more '-T permissive' options.
----------------------------------------------------------------------------

Did you apply the libata patch? I saw that here:

http://smartmontools.sourceforge.net/#testinghelp

I'm on kernel 2.6.10 and haven't applied any patches.. maybe it's
included on 2.6.11 now or a difference between smartctl 5.32 and 5.33?

The drives I have are on an Intel ICH5 SATA controller. I am doing a
few RAIDed partitions between a couple of 120GB drives since I
reinstalled my work machine a few weeks ago. I think I'm using libata
(the option marked as 'conflicting' with it isn't enabled in my
kernel). Any thoughts?

Derek

On Wed, 9 Mar 2005 11:53:11 +0100, peter.greis@ubs.com
<peter.greis@ubs.com> wrote:
> Good point about maxing out the pci bus... - I already use the nForce for mirrored boot drives, so that's not an option. The IDE controllers are empty at the moment (save for a DVD drive); I will give this a thought.
> 
> Thanks for the feedback,
> 
> -P
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Nicola Fankhauser
> Sent: Wednesday, March 09, 2005 10:48 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: now on to tuning....
> 
> hi peter
> 
> peter.greis@ubs.com wrote:
> > I have been lurking for a while.... I recently put together a raid 5
> > system (Asus K8NE SIL 3114/2.6.8.1 kernel) with 4 300GB SATA Seagate
> > drives (a lot smaller than the bulk of what seems to be on this
> > list!). Currently this is used for video and mp3 storage, being
> > Reiser on LVM2.
> 
> beware that LVM2 _can_ affect your performance. I too believed that the
> concept of dynamic drives is good, but I experienced a performance hit
> of about 50% (especially in sequential reads).
> 
> see my blog entry describing how I built my 2TB file-server at
> http://variant.ch/phpwiki/WikiBlog/2005-02-27 for some numbers and more
> explanation.
> 
> the K8NE has the same SiI 3114 controller as the board I used has; it is
> connected by a 33mhz 32bit PCI bus and maxes out at 133MiB/s, so for
> maxmimum performance you might want to connect only two drives to this
> controller, the other two to the nforce3 chipset SATA ports.
> 
> > Bonnie++ to test, but with which parameters ?
> 
> normally it's enough to specify a test-file larger (e.g. twice) the
> memory capacity of the machine you are testing. for a machine with 1GiB RAM:
> 
> # bonnie++ -s 2gb {other options}
> 
> you might as well want to specify the "fast" option which skips per-char
> operations (which are quite useless to test IMHO):
> 
> # bonnie++ -f {other options}
> 
> HTH
> nicola
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
