From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Tue, 20 Sep 2016 05:36:17 -0400
Message-ID: <57E10311.7040601@suse.com>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
 <57E0CB6C.2040000@suse.com>
 <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony DeRobertis <anthony@derobert.net>, linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids



On 09/20/2016 03:02 AM, Anthony DeRobertis wrote:
> On 09/20/2016 01:38 AM, Guoqing Jiang wrote:
>>
>> Thanks for report, could you try the latest tree 
>> git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git?
>> I guess 45a87c2f31335a759190dff663a881bc78ca5443 should resolve it , 
>> and I can add a spare disk
>> to native raid (internal bitmap) with different metadatas (0.9, 1.0 
>> to 1.2).
>
> (please keep me cc'd, I'm not subscribed)
>
> $ git rev-parse --short HEAD
> 676e87a
> $ make -j4
> ...
>
> # ./mdadm -a /dev/md/pv0 /dev/sdc3
> mdadm: add new device failed for /dev/sdc3 as 8: Invalid argument
>
> [375036.613907] md: sdc3 does not have a valid v1.0 superblock, not 
> importing!
> [375036.613926] md: md_import_device returned -22

The md-cluster code should only work raid1 with 1.2 metadata, and your 
array (/dev/md/pv0) is raid10 with
1.0 metadata (if I read bug correctly), so it is weird that your array 
can invoke the code for md-cluster.

I assume it only happens with existed array,  a new created one doesn't 
have the problem, right? And I can't
reproduce it from my side.

Which kernel version are you used to created the array in case the 
kernel was updated? Also pls show the
output of "mdadm -X $DISK", and your bitmap is a little weird (but I 
don't try with 10 level before, so maybe
it is correct).

Internal Bitmap : -234 sectors from superblock


Thanks,
Guoqing
