From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: AW: RAID1 and data safety?
Date: Thu, 24 Mar 2005 09:31:13 +1100
Message-ID: <16961.60977.412402.996171@cse.unsw.edu.au>
References: <76592C4D3DA1AC4FB8424084D10D31A80611526B@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Schuett Thomas EXT on Tuesday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 22, Thomas.Schuett.extern@mchh.siemens.de wrote:
> >Neil Brown wrote:
> >>> Is there any way to tell MD to [...] and
> >>> read-from-all-disks on a RAID1 array?
> >
> >Not sure why a checksum of X data blocks should be cheaper
> >performance-wise than a comparison between X data blocks, but I can
> >see the point in that you only have to load the data once and check
> >the checksum.  Not quite the same security, but almost.
> 
> Still, if there is different data on the two disks due to a previous 
> power failure, the comparsion could really be the better choise, isn't it?
> 

What does a comparison of two blocks tell you?  That they are
different, not which one is "right".

A filesystem designed to handle these sort of problems wouldn't suffer
from data inconsistencies due to power off.  It would "know" where it
was up to and would either re-write or ignore any data that it doesn't
know to certainly be safe.

NeilBrown
