From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Mon, 29 Jan 2018 16:23:07 +0100
Message-ID: <mqdvafkhep0.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi linux-raid, lsf-pc

(If you've received this mail multiple times, I'm sorry, I'm having
trouble with the mail setup).

With the rise of bigger and bigger disks, array rebuilding times start
skyrocketing.

In a paper form '92 Holland and Gibson [1] suggest a mapping algorithm
similar to RAID5 but instead of utilizing all disks in an array for
every I/O operation, but implement a per-I/O mapping function to only
use a subset of the available disks.

This has at least two advantages:
1) If one disk has to be replaced, it's not needed to read the data from
   all disks to recover the one failed disk so non-affected disks can be
   used for real user I/O and not just recovery and
2) an efficient mapping function can improve parallel I/O submission, as
   two different I/Os are not necessarily going to the same disks in the
   array. 

For the mapping function used a hashing algorithm like Ceph's CRUSH [2]
would be ideal, as it provides a pseudo random but deterministic mapping
for the I/O onto the drives.

This whole declustering of cause only makes sense for more than (at
least) 4 drives but we do have customers with several orders of
magnitude more drivers in an MD array.

At LSF I'd like to discuss if:
1) The wider MD audience is interested in de-clusterd RAID with MD
2) de-clustered RAID should be implemented as a sublevel of RAID5 or
   as a new personality
3) CRUSH is a suitible algorith for this (there's evidence in [3] that
   the NetApp E-Series Arrays do use CRUSH for parity declustering)

[1] http://www.pdl.cmu.edu/PDL-FTP/Declustering/ASPLOS.pdf 
[2] https://ceph.com/wp-content/uploads/2016/08/weil-crush-sc06.pdf
[3]
https://www.snia.org/sites/default/files/files2/files2/SDC2013/presentations/DistributedStorage/Jibbe-Gwaltney_Method-to_Establish_High_Availability.pdf

Thanks,
        Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
