From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] imsm: rebuild from 2-disk RAID10
Date: Wed, 16 Aug 2017 04:24:07 -0400
Message-ID: <e957846f-80dc-6cb1-21d8-77dad21b8577@gmail.com>
References: <1502372842-19381-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502372842-19381-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/10/2017 09:47 AM, Tomasz Majchrzak wrote:
> When RAID10 loses 2 disks and it is still operational, it cannot be
> rebuilt. The rebuild process starts for the first disk and completes,
> however completion is not recorded in metadata. There is an assumption
> that rebuild completion corresponds to transition from degraded to
> normal state. It's not the case for 2-disk RAID10 as it's still degraded
> after rebuild to first disk completes.
> 
> Check if disk rebuild flag is set in the second map and clear it. So far it
> has been checked only in the first map (where it was not set). The flag in
> the second map has not been cleared but rebuild completion dropped second
> map so the problem was not visible.
> 
> If rebuild completion is notified and array still has failed disks and is in
> degraded state, check first if rebuild position is really unset (the same
> check as for array in normal state). If so, mark migration as done but don't
> change array state (it should remain degraded). Update failed disk number.
> 
> On rebuild start don't clear the rebuild flag in the destination map for all
> the drives because failed state is lost for one of them. Just do a copy of
> a map and clear the flag in the destination map for the disk that goes into
> rebuild. Similarily preserve the rebuild flag in the map during disk removal.
> 
> If the disk is missing on array start and migration has been in progress,
> don't just cancel it. Check first if maybe one of the disks was not under
> rebuild (rebuild flag present both in source and destination map). If so,
> rebuild was running despite of failed disk so there is no need to cancel
> migration.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>

Applied!

Thanks,
Jes

