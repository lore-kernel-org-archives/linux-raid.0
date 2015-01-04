From: Aryeh Leib Taurog <vim@aryehleib.com>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Sun, 4 Jan 2015 12:20:09 +0200
Message-ID: <20150104102009.GA4511@deb76.aryehleib.com>
References: <54A6E5B1.2090602@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54A6E5B1.2090602@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 02, 2015 at 6:38 PM, Robert L Mathews wrote:
> Your question is about how to reassemble them without a resync,  
> which is understandable, but the reason md isn't doing that 
> automatically is that it thinks they might be different.
 
> I personally would always do a resync in such a case. A flaky cable 
> suggests that data on it is suspect, and this is one of the things  
> RAID 1 is for: it allows you to copy clean data to suspect 
> partitions.

> But I'm known to be data-paranoid. Other people may have different 
> opinions/suggestions.

Thanks.  I tend to agree.  Would the resync just copy all the data 
from the "good" drive back to the "failed" drive?  For diagnostic 
purposes, it would actually be a lot more informative to compare the 
two drives and see if there really is data corruption on one of them 
or not.  Is there a way to do that?  If I were to demonstrate that the 
data are in sync, I would want to reassemble without resync.

Also, in my situation, since for now I'm just using a pair of external 
drives, I could easily imagine accidentally trying to assemble the 
array when one of the drives is powered down.  Then this situation 
would arise again without faulty hardware.  I suppose an 'assemble' 
script could help protect against the latter case by checking first 
that both devices are available.

Prudence notwithstanding, I do think there are valid cases for 
reassembling this array without resync.  If there's a way to do that, 
I'd still like to know.

With appreciation,
Aryeh Leib Taurog
