From: Philip Molter <philip@corp.texas.net>
Subject: Re: Force parity resync on raid5?
Date: Tue, 10 Aug 2004 09:30:18 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4118DBFA.6020607@corp.texas.net>
References: <4118B9A8.2040102@corp.texas.net> <16664.49686.253255.828936@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16664.49686.253255.828936@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

> On Tuesday August 10, philip@corp.texas.net wrote:
> 
>>Linux RAID *has* to have sort of way to force a parity resync.  If it
>>doesn't have one, it needs one.  That's a glaring omission to make.
> 
> Well, you get what you pay for.....

Tell me where to send the checks.  Seriously.  I know you guys work hard 
on this stuff and I will gladly donate to the fund to have important (to 
me) features implemented.

> The easiest way to force a resync would be to re-create the array.
> 
>  - Note the exact order of the drives in the array, and the chunk size.
>  - Stop the array.
>  - Create the array with mdadm using --force.  That bit is important.

Do I need to note the parity algorithm, too?

>     mdadm --create /dev/mdX --level=5 --force --disks=whatever \
>        --chunksize=64k  /dev/sda1 /dev/sdb1 .....
> 
>  Remember the --force.  If you don't have it, you will get a recovery
>  cycle that rebuilds one drive against the others rather than a resync
>  that checks and corrects parity.
> 
>  This will recreate the array (almost) exactly as it currently is, but
>  it will not be marked 'clean', so a parity check-and-correct will
>  happen.

Does this destroy the data on the array?  I seem to remember getting 
this advice a while back when encountering a similar problem and seeing 
my data go up in smoke.  I could easily have done something wrong, though.
