From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Intel fakeraid working?
Date: Thu, 05 Apr 2012 14:23:16 -0400
Message-ID: <4F7DE314.9040306@ubuntu.com>
References: <4F7CEDD0.9080904@ubuntu.com> <20120405111317.2a5227b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405111317.2a5227b1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/4/2012 9:13 PM, NeilBrown wrote:
>
> That bug is fixed by
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=c744a65c1e2d59acc54333ce80a5b0702a98010b
>
> and is not specific to Intel IMSM RAID.

That commit appears to have to do with shutdown, but this did not happen 
during shutdown.  I suppose it happened as a result of the array being 
stuck in read only mode due to the missing mdmon.


