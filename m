From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: md on partition
Date: Sat, 23 Oct 2004 02:07:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410230607.i9N677N10676@www.watkins-home.com>
References: <1098466068.3179.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098466068.3179.41.camel@localhost.localdomain>
To: mingz@ele.uri.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found this old message:
"On Tuesday June 1, maheshext3@yahoo.com wrote:
> 
> --- Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > 
> > What does
> >    ls -l /dev/hd[eg]5
> > show? How about
> >    cat /proc/partitions
> >    dd if=/dev/hde5 of=/dev/null bs=1024k
> 
> Thanks a lot, Neil, turns out those nodes were not present. After I 
> mknod'd them, all's fine in RAIDland...
>   Quick question: does using extended partitions for RAID affect 
> performance?

The fact that the partitions are "extended" is invisible to most of the
kernel, and it could not have any affect of performance.

NeilBrown"

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ming Zhang
Sent: Friday, October 22, 2004 1:28 PM
To: linux-raid@vger.kernel.org
Subject: md on partition

Hi folks.

I remembered that there was a discussion on the list about some abnormal
performance penalty if u use a partition instead of a whole disk for MD.
But I could not find this discussion via archival or google.

Could somebody be kindly enough to point me to the right spot? Thanks a
lot.

Ming


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

