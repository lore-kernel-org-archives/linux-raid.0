From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Tue, 25 Mar 2008 08:00:10 +0000
Message-ID: <8C237F49-138E-43CA-A63C-6025E9E0EAE2@cam.ac.uk>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk> <18408.36712.100712.499844@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.36712.100712.499844@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thanks for your reply!

On 25 Mar 2008, at 05:36, Neil Brown wrote:
> On Thursday March 13, aia21@cam.ac.uk wrote:
>>
>> Is there a better way to do this?  I am hoping someone will tell me  
>> to
>> use option blah to utility foo that will do this for me without  
>> having
>> to break the mirror twice and resync each time.  (-;
>
> Sorry, but no.  This mode of operation was never envisaged for md.
> I would always put the md/raid1 devices below the LVM.

We do that already.  (-:  And then we put MD on top again.  What we  
have is two computers, each with six 500GB disks, set up as MD RAID-10  
+ 1 hot spare on the six disks.  Then run LVM on the MD RAID-10 and  
create two virtual drives on the LVM on each box.  Then on each box we  
have one of the LVM drives feed into an MD RAID-1 mirror and the other  
LVM drive is exported via iSCSI (iscsitarget) to the other box.  The  
iSCSI drive is then imported by the other box using open-iscsi and the  
resulting device is fed into the other half of the MD RAID-1 mirror on  
that box.

So yes, I am sure you never envisaged this mode of operation!  But it  
is a way to give us synchronous data replication across two sites  
(there are about 3 miles between the two boxes) with free software  
which in combination with my custom scripting and heartbeat2 allows us  
to fail the storage (the MD RAID-1 are xfs formatted and the NFS  
exported) over from one site to the other at the flip of a switch and  
in case of one machine blowing up, etc.

> Every time you buy two drives, combine them into a RAID1, and add the
> /dev/mdX as a PV for LVM.  Then grow you LVM devices whenever you
> like.
>
>> If not, please consider this a feature request for mdadm.  (-:  It
>> should have an option to detect that the underlying device has grown
>> and thus write a new superblock  (or move the old one or whatever) at
>> the end of the newly grown device instead of complaining that it does
>> not exist.  Or something!  As it is, it is incredibly time consuming
>> and inefficient.  )-:
>
> I'll keep it in mind (Which it to say:  I will save this in my 'mdadm'
> mailbox, and have a look through that mailbox next time I'm working on
> improvements to mdadm).


Great, thanks!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

