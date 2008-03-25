From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 initial resync: faster vs more secure
Date: Tue, 25 Mar 2008 16:15:43 +1100
Message-ID: <18408.35455.355616.973487@notabene.brown>
References: <47E297AB.8020001@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hubert Verstraete on Thursday March 20
Sender: linux-raid-owner@vger.kernel.org
To: Hubert Verstraete <hubskml@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 20, hubskml@free.fr wrote:
> Hi list
> 
> Each time I create a RAID5 array, by default, as a degraded array with a 
> spare, I cannot stop and restart the array unless the initial resync has 
> completed. If I do so, the resync is not resumed when the array is 
> re-assembled.
> Is this due to the fact that one disk is a spare, but md actually 
> doesn't know which of the disks is the spare one ?

No.  It is due to that fact that the v0.90 metadata has no convenient
place to record how far the recovery has progressed.

If you use --metadata=1 when creating the array, it will be able to
record the status of incomplete recovery and restart is properly.

NeilBrown


> 
> Assuming that there is no bug and no workaround about this issue, I 
> think the following: when one cannot guarantee the array won't be 
> stopped until the resync completes, one should better create the RAID5 
> array with the -f option. Indeed, when I use -f, I can stop the array 
> and restart it, the resync will be resumed where it had stopped.
> The cost of this is that the initial resync runs slower.
> 
> Comments are welcome.
> 
> Thanks,
> Hubert
> 
> PS: the reshape patch from Neil on 03/03/08 does not fix the issue.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
