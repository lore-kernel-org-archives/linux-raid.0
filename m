From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH V3 08/11] mdadm: add the ability to change cluster name
Date: Tue, 26 May 2015 16:38:33 +0800
Message-ID: <55643109.70009@suse.com>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>	<1432092043-24220-9-git-send-email-gqjiang@suse.com> <20150525145310.6b6ff7f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150525145310.6b6ff7f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

NeilBrown wrote:
> On Wed, 20 May 2015 11:20:40 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:
>
>   
>> To support change the cluster name, the commit do the followings:
>>
>> 1. extend original write_bitmap function for new scenario.
>> 2. add the scenarion to handle the modification of cluster's name
>>    in write_bitmap1.
>> 3. make update_super1 can change the name in mdp_superblock_1.
>>     
>
> You haven't documented --update=home-cluster in mdadm.8.in, or at
>
> 			fprintf(outf, "Valid --update options are:\n"
>   
Sorry, I will add it.
> Also, I just realised that you are storing the cluster name in the array
> name.  I don't think that is a clever idea.
> The cluster name can be 64 chars.  The array name can only be 32.
>
>   
Yes, you are correct. The array name is combined by homecluster and
homehost.
Generally, it doesn't have problem since people don't set the longer
name generally,
of course it is better to double check the length.

if  strlen( homecluster + homehost) < 32
    set the new name
else
    tell the user new cluster is too long, return
> I think leave homehost and homecluster completely out of the array name when
> the array is clustered.  
Could you please elaborate more about it? Does it mean add extra cluster
member in
superblock? Something like:

diff --git a/super1.c b/super1.c
index b949f5e..4ea1115 100644
--- a/super1.c
+++ b/super1.c
        char    set_name[32];   /* set and interpreted by user-space */
+       char    cluster_name[64];

If so, the kernel code also need related modification.

Or just let the bitmap stores the clustername, and the set_name doesn't
need to
be change,  then display the clustername from bitmap when run 'mdadm -E/D'.

Thanks,
Guoqing
