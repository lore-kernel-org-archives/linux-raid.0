From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH V3 08/11] mdadm: add the ability to change cluster name
Date: Mon, 01 Jun 2015 11:26:33 -0500
Message-ID: <556C87B9.4010902@suse.com>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>	<1432092043-24220-9-git-send-email-gqjiang@suse.com> <20150525145310.6b6ff7f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150525145310.6b6ff7f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 05/24/2015 11:53 PM, NeilBrown wrote:
> On Wed, 20 May 2015 11:20:40 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:
>
>> To support change the cluster name, the commit do the followings:
>>
>> 1. extend original write_bitmap function for new scenario.
>> 2. add the scenarion to handle the modification of cluster's name
>>     in write_bitmap1.
>> 3. make update_super1 can change the name in mdp_superblock_1.
>
> You haven't documented --update=home-cluster in mdadm.8.in, or at
>
> 			fprintf(outf, "Valid --update options are:\n"
>
> Also, I just realised that you are storing the cluster name in the array
> name.  I don't think that is a clever idea.
> The cluster name can be 64 chars.  The array name can only be 32.
>
> I think leave homehost and homecluster completely out of the array name when
> the array is clustered.
>
> and
>> +	    new_name = xmalloc(sizeof(sb->set_name));
>
> is really unnecessary.  Just do "char new_name[32];".
> But you are probably going to remove that code anyway.
>

We had decided to keep the clustername in the array name, instead of the 
homehost, when we create a new array because the arrayname carries the 
hostname of the node which creates the device. However, we differentiate 
the hostname and the clustername by the number of colons.

For non-clustered-

arrayname:hostname

For clustered-

arrayname::clustername

Since, this is a limited size, we can truncate the name instead of 
erring. Some tricks with strncpy should work fine.

This is for information purposes is only and not used for anything 
(including joining the cluster)

However, leaving the homehost and homecluster out of the arrayname seems 
a better option than providing half-baked information.

Guoqing, you may have to change the "create" patch accordingly.

<snipped>

-- 
Goldwyn
