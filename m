From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Convert raid5 to raid1?
Date: Thu, 10 Mar 2005 22:09:18 -0500
Message-ID: <200503110309.j2B39N522979@www.watkins-home.com>
References: <4230E003.4040609@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <4230E003.4040609@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'John McMonagle' <johnm@advocap.org>, 'Brad Campbell' <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You asked:
"raid5 with 3 drives and 1 spare
or 2 - 2 drive raid1 drives have the same space.
Which is less likely to have a failure cause data loss?"

Assume 4 drives.

	With RAID5 using 3 drives and 1 spare...
======================================================
If a disk is kicked out because of a bad block, a re-build starts, no
problem here.  Data redundancy is lost until the re-build finishes.

If during the re-build, a second bad block exists on any of the 2 remaining
disk, then another disk is kicked out.  You array is now down.  The data can
be recovered, but it is tricky.

	With RAID 1+0, 4 disks no spare.
======================================================
If a disk is kicked out because of a bad block, no problem.  Data redundancy
is lost until the fail disk is replaced and a re-build finishes.

Now only 1 of the remaining 3 disks has high risk.  If that disk gets a bad
block, game over, the array goes off-line, however, the data is not really
lost and can be recovered, but still tricky.

==========================================================================

	With RAID 1, 1+0 and 5 if the 2 bad blocks occur on the same stripe,
then the data on the bad blocks is really gone, but that is very un-likely.

	So, IMO, RAID5 has a higher risk of going off-line do to multi block
(multi disk) failures.  RAID1 has less risk.  Assuming the same number of
disks.  Also, as the number of disks increases, the risk of failure on RAID5
goes up, and the risk on RAID1 goes down.

	RAID6 can survive 2 failed disks, very unlikely to have 2 more bad
blocks during a re-sync.  However, RAID6 with 3 disks and 1 spare is
useless.  But RAID6 with 4 disks should be more reliable than RAID1+0.  But
I am not convinced RAID6 is stable yet.  Others disagree with me.  I hope
they are correct.

	Raid1+0 and RAID10 are similar, but different.
RAID1+0 is a RAID0 array made up of 2 or more RAID1 arrays.  Each RAID1
array could lose 1 disk and the RAID0 array should continue to function.

RAID10 supports an odd number of disks.  In the case of an odd number of
disks, only 1 disk can fail, or the array goes off-line.  In the case of an
even number of disks, I am not sure how many disks can fail with out the
array going off-line.  RAID10 is also new, but I have not heard anything bad
(or good) about it.

Anything I say is my opinion.  My opinions are the best!  :)

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of John McMonagle
Sent: Thursday, March 10, 2005 7:02 PM
To: Brad Campbell
Cc: linux-raid@vger.kernel.org
Subject: Re: Convert raid5 to raid1?

Brad

Not saying its broke.
Part of my reasoning to go to raid5 was that I could expand.
While it can be done I don't really see it as practical.
Also it's looking like I probably will not need to expand.

raid5 with 3 drives and 1 spare
or 2 - 2 drive raid1 drives have the same space.
Which is less likely to have a failure cause data loss?

I'm guessing raid1.
If I'm wrong I'd like to know now.

Also concerned about the resync times. It was going to take a couple 
days to resync under a rather light load if it weren't for the fact that 
it couldn't because of a bad drive and a kernel panic caused by the read 
error.
Still not certain about the cause of problem my current guess is the 
sata controller.

I'm glad there is work being done on the resync issue.
Also think the ideas to attempt to fix read errors are great.
My only suggestion is that there should be provision to send 
notification when it happens.
With both that would really help.

John

Brad Campbell wrote:

> John McMonagle wrote:
>
>> Was planning to adding a hot spare to my 3 disk raid5 array and was 
>> thinking if I go to 4 drives I would be a  better off  as 2 raid1 
>> arrays considering the current state of raid5.
>
>
> I just wonder about the comment "considering the current state of 
> raid5". What might be wrong with raid5 currently? I certainly know a 
> number of people (me included) who run several "large" raid-5 arrays 
> and don't have any problems.
>
> Brad


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

