From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Thu, 12 Nov 2009 00:50:19 -0500
Message-ID: <yq1tyx0l2as.fsf@sermon.lab.mkp.net>
References: <4AF7066C.1040507@tmr.com>
	<70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	<f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	<f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	<yq1ljienxql.fsf@sermon.lab.mkp.net>
	<f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	<yq11vk6nnrh.fsf@sermon.lab.mkp.net>
	<87f94c370911101301v4b71ce74hbd4ebd20e7ce2419@mail.gmail.com>
	<yq1ocnam1k5.fsf@sermon.lab.mkp.net>
	<87f94c370911110900h776286d9xba8d7f696dec18c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370911110900h776286d9xba8d7f696dec18c1@mail.gmail.com>
	(Greg Freemyer's message of "Wed, 11 Nov 2009 12:00:15 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> So for a workload mostly composed of small files residing on a MD
Greg> raid 4/5/6 setup, how is this supposed to work.  (ie. Tiffs, small
Greg> word docs, pdfs, individual emails, etc.)

The intent of thin provisioning is not to free up 4KB of space when you
delete an email.  The intent is to free 4GB when you delete a database
or a virtual machine disk image.

In the RAID array space, allocation units bigger than a single stripe
are common.  I'm not aware of any arrays that track sectors or
filesystem block sized chunks.

We're exposing as much information about the mapping granularity as the
hardware is willing to share.  This is done so that filesystems have the
option of laying out data accordingly.  For instance a filesystem can
choose to reuse recently freed blocks and to pack data tightly together
instead of the traditional approach of spreading things out over the
entire LBA range.


Greg> Most of the individual files will be less than one stripe wide, so
Greg> when they are deleted I gather the discard range will be less than
Greg> a stripe and therefore MD would ignore it in the simplest of
Greg> implementations.  ie. Without coalescence at some point, MD will
Greg> never forward discards to the hardware.

Greg> Thus I would think for that workload, the nightly full freespace
Greg> scan and discard would be the best solution.

Well that's certainly possible to implement for small setups.  And less
tedious than tracking individual sector mapping in MD.

-- 
Martin K. Petersen	Oracle Linux Engineering
