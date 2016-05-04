From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/2] Check node nums for cluster raid
Date: Wed, 04 May 2016 11:25:00 -0400
Message-ID: <wrfjy47pvoab.fsf@redhat.com>
References: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
	<wrfjinytx3fv.fsf@redhat.com>
	<305eaf9b-1275-f9b9-dae4-1be8f21ed98c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <305eaf9b-1275-f9b9-dae4-1be8f21ed98c@redhat.com> (Doug Ledford's
	message of "Wed, 4 May 2016 11:19:17 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford <dledford@redhat.com> writes:
> On 05/04/2016 11:12 AM, Jes Sorensen wrote:
>> Guoqing Jiang <gqjiang@suse.com> writes:
>>> For cluster raid, we do need at least two nodes for it,
>>> the two patches add the checks before create and change
>>> bitmap.
>>>
>>> Thanks,
>>> Guoqing    
>>>
>>> Guoqing Jiang (2):
>>>   Create: check the node nums when create clustered raid
>>>   super1: don't update node nums if it is not more than 1
>>>
>>>  Create.c | 7 ++++++-
>>>  super1.c | 5 +++++
>>>  2 files changed, 11 insertions(+), 1 deletion(-)
>> 
>> Hi Guoqing,
>> 
>> I am a little confused on this one - albeit I haven't looked at it in
>> detail. Why should it not be possible to start a cluster with one node?
>> In theory you should be able to do that, and then add nodes later?
>
> Not typically.  A single node of a cluster is likely the odd man out, so
> starting it and allowing changes to the underlying device has a high
> potential of creating split brain issues.  For that reason, most cluster
> setups require some minimum (usually 2) for a quorum before they will
> start.  Otherwise, given a three node cluster, you could end up with
> three separate live filesystems and the need to merge changes between
> them to bring the cluster back into sync.

Valid point, but it still looks like a duplicate of the classic raid1
situation. We still allow the creation of a raid1 with just one drive,
would it not make more sense to spit out a warning here, rather than
deny it?

Cheers,
Jes
