From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 0/2] Check node nums for cluster raid
Date: Wed, 4 May 2016 23:03:11 -0400
Message-ID: <572AB7EF.6090403@suse.com>
References: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
 <wrfjinytx3fv.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjinytx3fv.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jes,

On 05/04/2016 11:12 AM, Jes Sorensen wrote:
> Guoqing Jiang <gqjiang@suse.com> writes:
>> For cluster raid, we do need at least two nodes for it,
>> the two patches add the checks before create and change
>> bitmap.
>>
>> Thanks,
>> Guoqing
>>
>> Guoqing Jiang (2):
>>    Create: check the node nums when create clustered raid
>>    super1: don't update node nums if it is not more than 1
>>
>>   Create.c | 7 ++++++-
>>   super1.c | 5 +++++
>>   2 files changed, 11 insertions(+), 1 deletion(-)
> Hi Guoqing,
>
> I am a little confused on this one - albeit I haven't looked at it in
> detail. Why should it not be possible to start a cluster with one node?
> In theory you should be able to do that, and then add nodes later?

The "nodes" means how many nodes could run with the clustered raid.
IOW, if nodes is set to 1, then we can't assemble the clustered raid in
node B after clustered raid is created in node A.

And we had provided below protection in md-cluster.c, so it doesn't make
sense to create clustered raid with "nodes = 1" since we can't use this raid
across cluster.

f (nodes < cinfo->slot_number) {
                 pr_err("md-cluster: Slot allotted(%d) is greater than 
available slots(%d).",
                         cinfo->slot_number, nodes);
                 ret = -ERANGE;
                 goto err;
}

Regards,
Guoqing
