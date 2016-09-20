From: Anthony DeRobertis <anthony@derobert.net>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Tue, 20 Sep 2016 03:02:39 -0400
Message-ID: <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
 <57E0CB6C.2040000@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E0CB6C.2040000@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids

On 09/20/2016 01:38 AM, Guoqing Jiang wrote:
>
> Thanks for report, could you try the latest tree 
> git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git?
> I guess 45a87c2f31335a759190dff663a881bc78ca5443 should resolve it , 
> and I can add a spare disk
> to native raid (internal bitmap) with different metadatas (0.9, 1.0 to 
> 1.2).

(please keep me cc'd, I'm not subscribed)

$ git rev-parse --short HEAD
676e87a
$ make -j4
...

# ./mdadm -a /dev/md/pv0 /dev/sdc3
mdadm: add new device failed for /dev/sdc3 as 8: Invalid argument

[375036.613907] md: sdc3 does not have a valid v1.0 superblock, not 
importing!
[375036.613926] md: md_import_device returned -22

So current master seems to be back to broken completely. It's 3AM here, 
will check more (and do another bisect, to find when it went from 
weird-errors-but-works to broken) tomorrow.
