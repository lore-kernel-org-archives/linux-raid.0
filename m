From: Phil Turmel <philip@turmel.org>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Tue, 17 Dec 2013 14:43:18 -0500
Message-ID: <52B0A956.7030501@turmel.org>
References: <20131217065028.GC20941@nx5.priv> <20131217165348.GA5070@localhost.localdomain> <52B09027.5090605@turmel.org> <20131217192637.GB5070@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131217192637.GB5070@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Julie Ashworth <ashworth@berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/17/2013 02:26 PM, Julie Ashworth wrote:
> Thanks Phil,
> I should note that the drives are labelled "enterprise", purchased from a hw RAID vendor (ACNC.com).
> 
> On 17-12-2013 12.55 -0500, Phil Turmel wrote:
>> Please post the output of "smartctl -x" for both of these drives.
> 
> The Centos5 smartctl (from smartmontools rpm) doesn't support the -x option. However, it's apparently equivelent to:
> smartctl -H -i -g all -c -A -f brief -l xerror,error -l xselftest,selftest -l selective -l directory -l scttemp -l scterc -l devstat -l sataphy 
> 
> Centos5 smartctl supports the following:
>  smartctl -H -i -c -A -l error -l selftest -l selective -l directory -l scttemp -l scttempsts -l scttemphist
> 
> ... and I enclosed the output for sda and sdb.
> If you think it would be useful to have the additional options (provided by -x), then let me know, and I'll try to build it.

I was interested in the reallocation counts, the current pending
sectors, and the scterc timeouts.  The latter were not present, and are
important.

But /dev/sdb has three relocations and only one pending error.  That's
an old drive, but not sick.  I'd be concerned that there're other
hardware issues in your system if the timeout issue is not part of the
problem.

>> timeout mismatches combined with lack of scrubbing.
> 
> I've read about mismatches, but not about scrubbing. I'll investigate this.
> What program/options do your weekly scrub?

Simple weekly cron job does "echo check >>/sys/block/mdX/md/sync_action"
for each array.

>> Maybe not.  Please tell us you know all about error recovery timeouts
> 
> Instead of stopping the sync, I decided to slow it down:
> echo 1001 > /proc/sys/dev/raid/speed_limit_max
> 
>> and the timeout mismatch problem commonly encountered with
>> consumer-grade hard drives.  Otherwise, you might want search the list
>> archives for various combinations of the keywords "scterc", "error
>> recovery", "timeout mismatch", "URE", and/or "bit error rate".
> 
> I'm not a big fan of Seagate (enterprise or not). The drives I purchased before these (~2008) needed to have firmware updates to prevent bricking. Sigh.

That Seagate part number twigged an old memory... I didn't think it was
an enterprise drive.  I have had good experiences with Hitachi, FWIW.
Recent purchases have all been WD Red just for this issue.

Phil
