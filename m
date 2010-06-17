From: Brett Russ <bruss@netezza.com>
Subject: Re: [md PATCH 00/16] bad block list management for md and RAID1
Date: Thu, 17 Jun 2010 08:48:07 -0400
Message-ID: <hvd5iq$u83$1@dough.gmane.org>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/2010 08:07 PM, NeilBrown wrote:
> The goal of these patches is to add a 'bad block list' to each device
> and use it to allow us to fail single blocks rather than whole
> devices.

Hi Neil,

This is a worthwhile addition, I think.  However, one concern we have is 
there appears to be no distinction between media errors (i.e. bad 
blocks) and other SCSI errors.  One situation we commonly see in the 
enterprise is non-media SCSI errors due to i.e. path failure.  We've 
tested dm multipath as a solution for that but it has its own problems, 
primarily performance due to its apparent decomposition of large 
contiguous I/Os into smaller I/Os and we're investigating that.  Until 
that is fixed, we have patched md to retry failed writes (md already has 
a mechanism for failed reads).  Commonly these retries will succeed as 
many of the path failures we've seen have been transient (i.e. a SAS 
expander undergoes a reset).  Today in the vanilla md code that would 
cause a drive failure.  In this patch, it would identify a range of 
blocks as bad.  Presumably later they might be revalidated and removed 
from the bad block list if the original error(s) were in fact transient, 
but in the meantime we lose that member from any reads.

As an aside, it would be handy to have mechanisms exposed to userspace 
(via mdadm) to display, test, and possibly override the memory of these 
bad blocks such that in these instances where md has (possibly 
incorrectly) forced a range of blocks unavailable on a member that we 
can recover data if the automated recovery doesn't succeed.

Do you have thoughts or plans to behave differently based on the type of 
error?  I believe today the SCSI layer only provides pass/fail, is that 
correct?  If so, plumbing would need to be added to make the upper layer 
aware of the nature of the failure.  It seems that the bad block 
management in md should only take effect for media errors and that there 
should be more intelligent handling of other types of errors.  We would 
be happy to help in this area if it aligns with your/the community's 
longer term view of things.

Thanks,
Brett

