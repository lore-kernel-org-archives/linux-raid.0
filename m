From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Adaptec aacraid
Date: Sun, 14 Mar 2004 22:28:48 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040315042848.GA3941@lists.us.dell.com>
References: <Pine.LNX.4.58.0403141803560.1969@web1.mmaero.com> <4054F4EA.8050805@adaptec.com> <Pine.LNX.4.58.0403141930000.1969@web1.mmaero.com> <40550010.1020603@adaptec.com> <Pine.LNX.4.58.0403142056490.1969@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0403142056490.1969@web1.mmaero.com>
To: jlewis@lewis.org
Cc: Scott Long <scott_long@adaptec.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 14, 2004 at 09:14:50PM -0500, jlewis@lewis.org wrote:
> I just took another look, and actually what it did was much worse.  It
> looks at grub.conf and then rm's modules from /lib/modules for all kernels
> mentioned in grub.conf and then installs its own (if it has one).  This
> left me with:
> 
> # rpm -V kernel-smp-2.4.20-30.9
> .M......   /dev/shm
> missing    /lib/modules/2.4.20-30.9smp/kernel/drivers/scsi/aacraid
> missing    /lib/modules/2.4.20-30.9smp/kernel/drivers/scsi/aacraid/aacraid.o
> 
> and no aacraid module anywhere in /lib/modules/2.4.20-30.9smp/.
> 
> Fortunately, it didn't blow away the 2.4.20-30.9smp initrd, so I was able
> to extract the missing module from that, and put it back in place.  I know
> the system would have booted just fine (since the module was in the
> initrd)...but man, that's _really_annoying_ behavior for an RPM.  I
> haven't bothered reading the whole script (25kb), but AFAICT, it rm'd the
> modules and did not leave backup copies of them anywhere I've looked.

<shameless plug>
FWIW, this is *exactly* the reason DKMS exists - because every vendor
who offers a driver update does it a little differently.  DKMS is
designed to standardize this, and make it really obvious when a given
driver has been updated, and to what version, for each kernel.
http://linux.dell.com/projects.shtml#dkms
</shameless plug>

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
