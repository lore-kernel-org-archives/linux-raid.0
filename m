From: David Brown <david.brown@hesbynett.no>
Subject: Re: Status of discard support in MD RAID
Date: Fri, 12 Sep 2014 11:03:19 +0200
Message-ID: <5412B6D7.1060400@hesbynett.no>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com> <26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 12/09/14 02:46, Chris Murphy wrote:
> 
> On Sep 11, 2014, at 5:38 PM, Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> Neil (or anyone else),
>> 
>> I know that trim/discard support was added back in 2012 (commit
>> 9db90880).  However, I thought there were still issues regarding
>> what happens when various sync operations occur.  I'd like to turn
>> on discard support in dm-raid.c (a oneline patch) if things are in
>> order.  I can enable any, all or none depending on your
>> recommendation.  (I assume RAID1/10 is easier than the parity
>> RAIDs.)
> 
> If all the controller and drive support it then it should pass
> through, but there's the problem whether the SSD supports
> deterministic trim. If it doesn't, a check check > md/sync_action
> will report mismatches in md/mismatch_cnt; and a repair will probably
> corrupt the volume. So you can still use trim with a drive that
> returns non-deterministic results with raid0/1/10, but you can't rely
> on the result of md/mismatch_cnt and you can't do repair type
> scrubs.
> 
> For raid5/6, it's a problem to use trim if the drive returns
> non-deterministically for trimmed blocks. I'd think that in addition
> to DRAT being supported, it'd need to support DZAT.
> 
> smartctl --identify=wb /dev/diskX | grep -i trim
> 
> 
> Chris Murphy
> 

Would it be possible to change trim/discard commands into write zero
blocks for some SSDs?  A number of SSD controllers support transparent
compression, so writing large batches of zeros will result in very small
writes to the actual flash, and the SSD controller will be able to
recycle flash used by the overwritten logical blocks just as if they
were trimmed.  Obviously writing zeros will take longer in transfer than
trim commands, but the result on the disk would be similar and it would
be guaranteed deterministic.

David


