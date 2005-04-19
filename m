From: Luca Berra <bluca@comedia.it>
Subject: Re: Trouble assembling multipath md devices between two nodes who see the same LUNs.
Date: Tue, 19 Apr 2005 09:20:36 +0200
Message-ID: <20050419072036.GC29247@percy.comedia.it>
References: <11008ab4f.ab4f11008@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11008ab4f.ab4f11008@bms.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 18, 2005 at 08:24:44PM -0400, Anu Matthew wrote:
>Thanks Larks. It is much appreciated. 
>
>If the original metadata written by hostA changes by "mdadm --assemble" running on hostB, will mdmpd be able to recover the failed links on hostA when they re-surface? I am asking this because, I guess unless hostA goes down, hostA reflects the new metadata written by hostB. Will mdmpd take the new uuid into account? 
DONT ACTIVATE THE ARRAY ON MORE THAN _1_ HOST AT THE SAME TIME.
whatever you do in the failover setup make it so that the md is
activated only on the active node.

>Not entirely OT, but devabel gets to the see the same uuid/serial numbers on the shared luns across hosts. It would have been cool if mdadm could too, right?
mdadm can use the UUID stored in the raid superblock, thus avoiding the
need to using devlabel (last time i looked at devlabel it was so buggy,
it could not make head or tails of a non partitioned disk)

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
