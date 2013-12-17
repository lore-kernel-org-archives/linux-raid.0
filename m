From: Phil Turmel <philip@turmel.org>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Tue, 17 Dec 2013 12:55:51 -0500
Message-ID: <52B09027.5090605@turmel.org>
References: <20131217065028.GC20941@nx5.priv> <20131217165348.GA5070@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131217165348.GA5070@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Julie Ashworth <ashworth@berkeley.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Julie,

On 12/17/2013 11:53 AM, Julie Ashworth wrote:
> hi all, The sync ran overnight, and smartctl reports 60 errors on
> /dev/sdb this morning. So, it seems like the drive is doomed.

You haven't actually posted enough data from smartctl to say that,
though failures in the vicinity of three years is not surprising.

Please post the output of "smartctl -x" for both of these drives.

> It's frustrating, because this has happened twice in the last month,
> where a disk failed in a RAID1, I replaced the drive, and the 'good'
> drive failed during the sync. Last time I rebuilt from scratch. I
> presume that is my fate this time.

"Good drives failing during rebuild" is a big red flag suggesting
timeout mismatches combined with lack of scrubbing.

> I plan to use RAID6 in the future, but I still have important servers
> with RAID1 arrays. Do you folks recommend replacing HDDs before they
> report errors? The drives are all ~3 years old - Seagate.

I replace drives when they reach 10 relocations, given weekly scrubs.

> I should probably stop the sync. I presume the best way to do this is
> to fail/remove /dev/sda (the new disk).

Maybe not.  Please tell us you know all about error recovery timeouts
and the timeout mismatch problem commonly encountered with
consumer-grade hard drives.  Otherwise, you might want search the list
archives for various combinations of the keywords "scterc", "error
recovery", "timeout mismatch", "URE", and/or "bit error rate".

Phil
