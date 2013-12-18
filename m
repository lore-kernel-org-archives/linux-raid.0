From: Phil Turmel <philip@turmel.org>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Wed, 18 Dec 2013 07:08:37 -0500
Message-ID: <52B19045.5010102@turmel.org>
References: <20131217065028.GC20941@nx5.priv> <20131217165348.GA5070@localhost.localdomain> <52B09027.5090605@turmel.org> <20131217192637.GB5070@localhost.localdomain> <52B0A956.7030501@turmel.org> <20131218034556.GA9457@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131218034556.GA9457@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Julie Ashworth <ashworth@berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/17/2013 10:45 PM, Julie Ashworth wrote:
> hi Phil,
> thanks again for your help. It was surprisingly easy to install the latest smarmontools.
> 
> On 17-12-2013 14.43 -0500, Phil Turmel wrote:
>> I was interested in the reallocation counts, the current pending
>> sectors, and the scterc timeouts.  The latter were not present, and are
>> important.
> 
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    3
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    1
> SCT Error Recovery Control:
>            Read:    100 (10.0 seconds)
>           Write:    100 (10.0 seconds)
> 
> (I also attached the full output)
> 
> I verified that a weekly scrub is performed via cron (default with Centos5), and there were no errors detected prior to the sync. The output is included in syslog reports. 

Very good.  You do not have a timeout mismatch problem.  But the
behavior of /dev/sdb does not match its health.  That suggests some
other problem is present, like a bad SATA cord or socket, a bad power
supply, bad cooling, et cetera.

>> But /dev/sdb has three relocations and only one pending error.  That's
>> an old drive, but not sick.  I'd be concerned that there're other
>> hardware issues in your system if the timeout issue is not part of the
>> problem.
> 
> Should I run the sync (mdadm -a) in verbose mode? If so, what is the best way to terminate the current sync? By failing/removing /dev/sda?

I'd let the sync continue until it fails or completes.  And if it
completes, exercise the array to see if it stays flaky.  If it does not
complete, start swapping parts in the system.

Regards,

Phil

ps.  I'll be offline all day today--I'm sure the list will chip in if
you need more help.
