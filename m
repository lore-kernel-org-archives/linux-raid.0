From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm break / restore soft mirror
Date: Thu, 13 Dec 2007 12:19:17 +1100
Message-ID: <18272.34965.638276.892803@notabene.brown>
References: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brett Maton on Wednesday December 12
Sender: linux-raid-owner@vger.kernel.org
To: Brett Maton <Brett.Maton@simplyhealth.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 12, Brett.Maton@simplyhealth.co.uk wrote:
> Hi, 
> 
>   Question for you guys. 
> 
>   A brief history: 
>   RHEL 4 AS 
>   I have a partition with way to many small files on (Usually around a couple of million) that needs to be backed up, standard
> 
>   methods mean that a restore is impossibly slow due to the sheer volume of files. 
>   Solution, raw backup /restore of the device.  However the partition is permanently being accessed. 
> 
>   Proposed solution is to use software raid mirror.  Before backup starts, break the soft mirror unmount and backup partition
> 
>   restore soft mirror and let it resync / rebuild itself. 
> 
>   Would the above intentional break/fix of the mirror cause any problems? 

No, it should work fine.

If you can be certain that the device that you break out of the mirror
is never altered, then you could add an internal bitmap while the
array is split and the rebuild will go much faster.
However even mounting a device readonly will sometimes alter the
content (e.g. if ext3 needs to replay the journal) so you need to be
very careful.

NeilBrown
