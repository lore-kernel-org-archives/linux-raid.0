From: Luca Berra <bluca@comedia.it>
Subject: Re: Imaging Mirrored OS Drives
Date: Wed, 16 Aug 2006 22:47:27 +0200
Message-ID: <20060816204727.GA12708@percy.comedia.it>
References: <44E35063.3040706@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44E35063.3040706@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 16, 2006 at 01:05:39PM -0400, andy liebman wrote:
if the imaging software is not too smart and creates the partitions and
filesystems with the exact same size as the original, yes.
(i mean that there should be some space between the end of the
filesystem and the end of the partition to store the md superblock)

>2) Furthermore, if the above is possible, in creating the arrays on the 
>new drives is there a way to force mdadm to give the arrays specific 
>UUID numbers? It looks like I can do that with mdadm --update? Should I 
>create the arrays first using the normal "mdadm -C" procedure, and then 
>update the UUIDs?
never tried that, let us know how you fare.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
