From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 17:38:50 -0500
Message-ID: <43CD71FA.4090908@cfl.rr.com>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru> <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CCD453.9070900@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: sander@humilis.net, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

Michael Tokarev wrote:
<snip>
> Compare this with my statement about "offline" "reshaper" above:
> separate userspace (easier to write/debug compared with kernel
> space) program which operates on an inactive array (no locking
> needed, no need to worry about other I/O operations going to the
> array at the time of reshaping etc), with an ability to plan it's
> I/O strategy in alot more efficient and safer way...  Yes this
> apprpach has one downside: the array has to be inactive.  But in
> my opinion it's worth it, compared to more possibilities to lose
> your data, even if you do NOT use that feature at all...
>
>   
I also like the idea of this kind of thing going in user space.  I was 
also under the impression that md was going to be phased out and 
replaced by the device mapper.  I've been kicking around the idea of a 
user space utility that manipulates the device mapper tables and 
performs block moves itself to reshape a raid array.  It doesn't seem 
like it would be that difficult and would not require modifying the 
kernel at all.  The basic idea is something like this:

/dev/mapper/raid is your raid array, which is mapped to a stripe between 
/dev/sda, /dev/sdb.  When you want to expand the stripe to add /dev/sdc 
to the array, you create three new devices:

/dev/mapper/raid-old:  copy of the old mapper table, striping sda and sdb
/dev/mapper/raid-progress: linear map with size = new stripe width, and 
pointing to raid-new
/dev/mapper/raid-new: what the raid will look like when done, i.e. 
stripe of sda, sdb, and sdc

Then you replace /dev/mapper/raid with a linear map to raid-new, 
raid-progress, and raid-old, in that order.  Initially the length of the 
chunks from raid-progress and raid-new are zero, so you will still be 
entirely accessing raid-old.  For each stripe in the array, you change 
raid-progress to point to the corresponding blocks in raid-new, but 
suspended, so IO to this stripe will block.  Then you update the raid 
map so raid-progress overlays the stripe you are working on to catch IO 
instead of allowing it to go to raid-old.  After you read that stripe 
from raid-old and write it to raid-new,  resume raid-progress to flush 
any blocked writes to the raid-new stripe.  Finally update raid so the 
previously in progress stripe now maps to raid-new. 

Repeat for each stripe in the array, and finally replace the raid table 
with raid-new's table, and delete the 3 temporary devices. 


Adding transaction logging to the user mode utility wouldn't be very 
hard either. 


