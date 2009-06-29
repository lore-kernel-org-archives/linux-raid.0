From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Adding a smaller drive
Date: Mon, 29 Jun 2009 10:45:23 -0400
Message-ID: <yq1bpo7hzek.fsf@sermon.lab.mkp.net>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
	<yq1eit411s4.fsf@sermon.lab.mkp.net>
	<87eit31hgq.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eit31hgq.fsf@frosties.localdomain> (Goswin von Brederlow's
	message of "Mon, 29 Jun 2009 12:07:17 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Goswin" == Goswin von Brederlow <goswin-v-b@web.de> writes:

>> The IDEMA LBA standard applies to 3.5" form factor drives over 160GB
>> as well as 2.5" FF drives over 80 GB.

Goswin> Is that realy exactly so many LBA sectors or at least as many?

Exactly that number.  IDEMA provides a precise formula for converting
marketing gigabytes to 512-byte (and 4KB) blocks.


Goswin> I don't really see anything wrong with a 500G drive having a few
Goswin> more sectors.

I do.  The whole purpose of the spec is to ensure that you can swap
drives in a RAID setup without having to find an exact replacement.  If
your array has drives with "extra" blocks then it becomes impossible to
swap in a drive that adheres to the IDEMA spec.


Goswin> And I know my Maxtor 200G disk is 3G bigger than Seagates.

200GB is old enough that the spec doesn't apply.  I know that
technically it says 160GB and above.  But in reality it took a while for
vendors to start adhering.  And the 200GB capacity point predates 160GB.

The usual rule of thumb is that 320GB vintage drives and above get it
right.  And any new drive, regardless of capacity.

-- 
Martin K. Petersen	Oracle Linux Engineering
