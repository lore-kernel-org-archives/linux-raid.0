From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: Slow RAID5 build on ata_piix vs. fast on sata_mv
Date: Mon, 15 Sep 2008 23:16:01 -0400
Message-ID: <20080916031601.GC24791@nexus.edgeofthenet.org>
References: <20080908175021.GA7730@nexus.edgeofthenet.org> <20080908213222.GB9484@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080908213222.GB9484@nexus.edgeofthenet.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'll reply to myself again, since I've solved the issue and figure it
might as well go into archives somewhere. :)

After discovering Adaptec acknowledged an issue these (and related)
drives on their controllers and provides updated drive firmware on their
website, I guess-timated a drive issue.  I obtained the new SN05
firmware directly from Seagate and the drives are performing much faster
on the Intel controller.

For good measure, I flashed the other three drives (on the Marvell
chipset controller), and they're still fine too.

Richard

On Mon, Sep 08, 2008 at 05:32:23PM -0400, Richard Michael wrote:
> Top-posting myself, I changed the motherboard BIOS (from IDE to AHCI)
> and initrd (adding ahci.ko), and the output of lspci makes a bit more
> sense:
> 
> SATA controller [0106]: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)
>   6 port SATA AHCI Controller [8086:2922] (rev 02)
> Kernel driver in use: ahci
> Kernel modules: ahci
> 
> 
> However, now the rebuild is even slower, at ~12MB/sec.
> 
> A disk on the ICH9R onboard controller (ahci):
> 
> # hdparm -tT /dev/sdd
> 
> /dev/sdd:
>  Timing cached reads:   8030 MB in  2.00 seconds = 4022.76 MB/sec
>  Timing buffered disk reads:  166 MB in  3.02 seconds =  54.98 MB/sec
> 
> 
> A disk on the PCI-X (sata_mv) controller:
> 
> # hdparm -tT /dev/sda
> 
> /dev/sda:
>  Timing cached reads:   8094 MB in  2.00 seconds = 4054.45 MB/sec
>  Timing buffered disk reads:  324 MB in  3.01 seconds = 107.73 MB/sec
> 
> 
> Googling reveals other people with slow AHCI disks on new (> 2.6.23)
> kernels.  Would someone using disks on an AHCI controller and a new
> kernel please send me timed reads?
> 
> This doesn't feel like a linux-raid issue anymore, perhaps I should take
> this to the lkml?
> 
> Perhaps I've missed something else in the BIOS..
> 
> Thanks,
> Richard
> 
> 
> 
> On Mon, Sep 08, 2008 at 01:50:21PM -0400, Richard Michael wrote:
> > On kernel 2.6.26.3 with mdadm 2.6.7, I'm building two RAID5 arrays of
> > three drives each from six Seagate 1TB drives (ST31000340NS) on two
> > different controllers.
> > 
> > Initial creation is rather slow for the array of disks on onboard
> > controller, about ~17MB/sec.  The creation of the array on the PCI-X
> > controller was much faster, about ~90MB/sec.  (Note: the creation is
> > sequential, I'm not creating these two arrays simultaneously.)
> > 
> > Three drives on one array are connected to the onboard SATA controller of
> > an Asus P5EWS Pro motherboard.  lspci shows me two IDE interfaces, one
> > four port and the other two port which I suppose correspond, in total,
> > to the six onboard ports:
> > 
> > Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)
> >   4 port SATA IDE Controller (rev 02)
> > Intel Corporation 82801I (ICH9 Family)
> >   2 port SATA IDE Controller (rev 02)
> > 
> > They both use the ata_piix kernel module.
> > 
> > 
> > The other controller is an eight port SuperMicro PCI-X controller,
> > AOC-SAT2-MV8, which has been mentioned on the list in the past:
> > 
> > Marvell Technology Group Ltd. 88SE6145 SATA II PCI-E controller (rev a1)
> > 
> > It uses the sata_mv kernel module.
> > 
> > 
> > I've created both RAID5 arrays with default parameters, using simply:
> >   mdadm --create /dev/md2 --raid-devices=3 --level=raid5
> >     /dev/sdd2 /dev/sde2 /dev/sdf2
> > 
> > 
> > hdparm shows me all drives are using udma6 (e.g. "hdparm -i /dev/sda"),
> > so I don't think it's a DMA issue (anyway, I've read all SATA drives use
> > DMA.. ?).
> > 
> > It seems like a controller issue.  Perhaps a different driver is
> > available for the onboard Intel controller; or some tunables in libata?
> > 
> > Any suggestions?
> > 
> > Thanks,
> > Richard
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
