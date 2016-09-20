From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Tue, 20 Sep 2016 01:38:52 -0400
Message-ID: <57E0CB6C.2040000@suse.com>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony DeRobertis <anthony@derobert.net>, linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids



On 09/19/2016 12:32 PM, Anthony DeRobertis wrote:
> (please cc me, I'm not subscribed.)
>
> mdadm 3.4 can not manage to add a spare to my array, it fails like:
>
>     # mdadm -a /dev/md/pv0 /dev/sdc3
>     mdadm: add new device failed for /dev/sdc3 as 8: Invalid argument
>
> and the kernel logs:
>
>     md: sdc3 does not have a valid v1.0 superblock, not importing!
>     md: md_import_device returned -22
>
> This worked in 3.3.4. I performed two git bisects and found that:
>
> a) it was broken by 95a05b37e8eb2bc0803b1a0298fce6adc60eff16
> b) it is sort-of fixed by 81306e021ebdcc4baef866da82d25c3f0a415d2d
>     (which AFAIK isn't yet released)
>
> I say sort of fixed in that it adds it to the array, but spits out some
> worrying errors (and I have no idea if it'd actually work, e.g., if it'd
> assemble again):
>
>     # ./mdadm -a /dev/md/pv0 /dev/sdc3
>     mdadm: Warning: cluster md only works with superblock 1.2
>     mdadm: Failed to write metadata to /dev/sdc3

Thanks for report, could you try the latest tree 
git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git?
I guess 45a87c2f31335a759190dff663a881bc78ca5443 should resolve it , and 
I can add a spare disk
to native raid (internal bitmap) with different metadatas (0.9, 1.0 to 1.2).

Pls let me know the result, I will look into it if the issue still exists.

Thanks,
Guoqing
