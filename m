From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: consistency detect
Date: Mon, 11 Oct 2004 20:05:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097539511.3103.78.camel@localhost.localdomain>
References: <1097465522.3111.24.camel@localhost.localdomain>
	 <16747.5613.417433.425637@cse.unsw.edu.au>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16747.5613.417433.425637@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-10-11 at 19:23, Neil Brown wrote:
> On Sunday October 10, mingz@ele.uri.edu wrote:
> > I have a question on RAID error detect. hope somebody can help me to
> > find it out. thanks.
> > 
> > take raid1 as an example, if one disk fail, raid 1 can detect the data
> > on disk is compromised and then reconstruct it using a spare disk. this
> > is straight forward.
> > 
> > but if one request comes to raid1 and raid1 sends requests to both
> > disks, at this time, system reboots because power outage, system
> > crashes, or any other reason. then after system reboots, how raid 1
> > detects which disk has consistent data? since before reboot, anything
> > can happen, data may in disk1 but not in disk2, or in disk2 but not in
> > disk1, or not in both disks, or already on both disks.
> 
> When you have a computer with a single drive, and it crashes due to
> power outage or similar, and it was in the process of writing data out
> to disk, the contents of those blocks that were being written is
> undefined.  It might have the old data.  It might have the new data.
> If there are multiple blocks being written, some might be "old", some
> might be "new".
> 
> Exactly the same is true with RAID1.  There is "right" value for any
> block that was in the process of being written.
> RAID1 simply chooses a value and makes sure that it is the same on
> both (all) drives.  It arbitrarily chooses the "first" drive in the
> array and copies that onto the rest.
> 
:) thanks a lot. so now i know what policy raid1 use. so raid1 will
randomly choose first drive and sync among all drives. so here comes to
another question. after a power loss and reboot, raid1 knows that there
are something wrong and potentially out of sync between two drives. will
it try to check and make sure two drives are in sync or it just leave
two drives there with potential unmatched blocks.

for example, before reboot, a write to location A happen in progress.
then after reboot. raid1 has no idea on previous write information. it
just knows something might happened and two drives are possible to be
out of sync. will it check whole drive to do a resync?



> > 
> > how raid1 or other raid code deal with this?
> 
> This sort of inconsistency is not really something for RAID to deal
> with.  It is something for the filesystem or application to deal
> with.  Possibly via journalling.  Possibly via 'fsck'.
> 
> NeilBrown
> 
> > 
> > 
> > ming
> > 
> > 
> > -- 
> >  --------------------------------------------------
> > | Ming Zhang, PhD. Student
> > | Dept. of Electrical & Computer Engineering
> > | College of Engineering
> > | University of Rhode Island
> > | Kingston RI. 02881
> > | e-mail: mingz at ele.uri.edu
> > | Tel. (401) 874-2293 
> > | Fax. (401) 782-6422
> > | http://www.ele.uri.edu/~mingz/
> > | http://crab.ele.uri.edu/gallery/albums.php
> >  --------------------------------------------------
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
 --------------------------------------------------
| Ming Zhang, PhD. Student
| Dept. of Electrical & Computer Engineering
| College of Engineering
| University of Rhode Island
| Kingston RI. 02881
| e-mail: mingz at ele.uri.edu
| Tel. (401) 874-2293 
| Fax. (401) 782-6422
| http://www.ele.uri.edu/~mingz/
| http://crab.ele.uri.edu/gallery/albums.php
 --------------------------------------------------


