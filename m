From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: md on partition
Date: Sat, 23 Oct 2004 18:52:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410232252.i9NMqYN14571@www.watkins-home.com>
References: <1098571121.3119.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098571121.3119.13.camel@localhost.localdomain>
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You said:
"will raid by default choose different chunk size if device size is
different, for example, sda is 400GB while sda1 is 50GB?"

No, but the random seek test will give different results.  50GB will perform
better, since less head travel.

Why the difference?  I would want everything the same for both tests.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ming Zhang
Sent: Saturday, October 23, 2004 6:39 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: md on partition

On Sat, 2004-10-23 at 12:12, Guy wrote:
> I guess Neil was wrong, or I misunderstood something.
> Were both test with the same RAID and LVM config?  Or was 1 RAID0 and the
> other RAID5?
yes, if i tested RAID0, then will use RAID0 for both partition or whole
disk scenarios.

> 
> If RAID5, are you sure the resync was done before you did your tests?
> "cat /proc/mdstat" to determine this.
> 
need to recheck. :)

> Yes, size does matter!  Chunk size that is.  Not sure about extent size.
> 
will raid by default choose different chunk size if device size is
different, for example, sda is 400GB while sda1 is 50GB?

> As long as the only difference was the whole disk vs partitions, then
> partitions make a big difference!  This sucks!
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ming Zhang
> Sent: Saturday, October 23, 2004 11:52 AM
> To: Guy
> Cc: linux-raid@vger.kernel.org
> Subject: RE: md on partition
> 
> thx but i met this problem.
> 
> i use 4 x 400GB SATA disks, i make a raid 0 or 5, and build a vg on top
> of md, then use bonnie++ to test read performance.
> 
> LVM (MD = sda+sdb+..) = 95MBsec, md is built on top of whole disk.
> 
> LVM (MD = sda1+sdb1+.) = 48MBsec, md is built on top of each partition.
> 
> so where is the problem? does md chunk size matter? or lvm extent size
> matters? thx.
> 
> 
> ming
> 
> On Sat, 2004-10-23 at 02:07, Guy wrote:
> > I found this old message:
> > "On Tuesday June 1, maheshext3@yahoo.com wrote:
> > > 
> > > --- Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > > > 
> > > > What does
> > > >    ls -l /dev/hd[eg]5
> > > > show? How about
> > > >    cat /proc/partitions
> > > >    dd if=/dev/hde5 of=/dev/null bs=1024k
> > > 
> > > Thanks a lot, Neil, turns out those nodes were not present. After I 
> > > mknod'd them, all's fine in RAIDland...
> > >   Quick question: does using extended partitions for RAID affect 
> > > performance?
> > 
> > The fact that the partitions are "extended" is invisible to most of the
> > kernel, and it could not have any affect of performance.
> > 
> > NeilBrown"
> > 
> > Guy
> > 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ming Zhang
> > Sent: Friday, October 22, 2004 1:28 PM
> > To: linux-raid@vger.kernel.org
> > Subject: md on partition
> > 
> > Hi folks.
> > 
> > I remembered that there was a discussion on the list about some abnormal
> > performance penalty if u use a partition instead of a whole disk for MD.
> > But I could not find this discussion via archival or google.
> > 
> > Could somebody be kindly enough to point me to the right spot? Thanks a
> > lot.
> > 
> > Ming
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


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

