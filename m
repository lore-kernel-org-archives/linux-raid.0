From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 2/3] md-cluster: introduce clear_clusterinfo_from_sb
Date: Fri, 27 Nov 2015 14:03:19 +0800
Message-ID: <5657F227.3030202@suse.com>
References: <1448008525-17095-1-git-send-email-gqjiang@suse.com> <1448008525-17095-2-git-send-email-gqjiang@suse.com> <87y4dk577c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y4dk577c.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: rgoldwyn@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 11/27/2015 01:42 PM, NeilBrown wrote:
> On Fri, Nov 20 2015, Guoqing Jiang <gqjiang@suse.com> wrote:
>
>> To change the bitmap from clustered to none, we also
>> need to clean related info about cluster from sb, such
>> as version, nodes and cluster_name.
> I've applied the other two (though I removed the __func__ and __LINE__
>  From error messages - they are just noise: the source of the message can
> easily be found with out them - I should remove all the others).
>
> However I haven't applied this because there doesn't seem to be any
> point.
> Once your told that main md superblock that there is no bitmap, it
> doesn't really matter what data is in the superblock of that
> non-existent bitmap - it will never be looked at.  Will it?
mdadm could still get nodes and cluster_name after change
bitmap to none, so some cmds like "mdadm -X /dev/sda" could
still see clustered info, it seems a little confused for user.

Thanks,
Guoqing

