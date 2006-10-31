From: Frido Ferdinand <frido@zolder.org>
Subject: New features?
Date: Tue, 31 Oct 2006 21:43:02 +0000 (UTC)
Message-ID: <20061031214301.GB17958@timor.isp-services.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Tue, Oct 31, 2006 at 08:50:19AM -0800, Mike Hardy wrote:
> >> 1 "Warm swap" - replacing drives without taking down the array but maybe
> >> having to type in a few commands. Presumably a sata or sata/raid
> >> interface issue. (True hot swap is nice but not worth delaying warm-
> >> swap.)
> > 
> > I believe that 2.6.18 has SATA hot-swap, so this should be available
> > know ... providing you can find out what commands to use.
> 
> I forgot 2.6.18 has SATA hot-swap, has anyone tested that?

Yeah, I've tracked the sata EH patches and now 2.6.18 for a while and
hotswap works. However if you pull the disk on a raidset the disk is set
as faulty and the device (/dev/sda for example) dissapears. If you
replug it, the device does not regain it's original devicename but but
will use the latest free 'slot' available (in a four disk layout that's
/dev/sde). Also trying to --remove the disk doesn't work since the
devicefile is gone. So be sure to --remove disks _before_ you pull it.

Anyone know if there's work being done to fix this issue, does 
this also happen on scsi ?

Regards,

        -- Frido

