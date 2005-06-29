From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Wed, 29 Jun 2005 14:42:33 +1000
Message-ID: <42C226B9.4000504@nighthawkrad.net>
References: <42BF67A2.6040601@nighthawkrad.net> <42C1F54B.1060405@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C1F54B.1060405@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Christopher Smith wrote:
> 
>>  stitch it together into a RAID1.  So, it looks like this:
>>
>>              "Concentrator"
>>                 /dev/md0
>>                  /     \
>>              GigE       GigE
>>                /         \
>>     "Disk node 1"       "Disk node 2"
>>
>> So far I've tried using iSCSI and GNBD as the "back end" to make the 
>> disk space in the nodes visible to the concentrator.  I've had two 
>> problems, one unique to using iSCSI and the other common to both.
> 
> 
> Personally, I wouldn't mess with iSCSI or GNBD. You don't need GNBD in 
> this scenario anyway; simple nbd (which is in the mainline kernel...get 
> the userland tools at sourceforge.net/projects/nbd) will do just fine, 
> and I'd be willing to bet that it is more stable and faster...

I'd briefly tried nbd, but decided to look elsewhere since it needed to 
much manual configuration (no included rc script, /dev nodes appear to 
have to be manually created - yes, I'm lazy).

I've just finished trying NBD now and it seems to solve both my problems 
- rebuild speed is a healthy 40MB/sec + and the failures are dealt with 
"properly" (ie: the md device goes into degraded mode if a component nbd 
suddenly disappears).  This looks like it might be a goer for the disk 
node/RAID-over-network back-end.

On the "front end", however, we have to use iSCSI because we're planning 
on doling the aggregate disk space out to a mix of platforms (some of 
them potentially clustered in the future) so they can re-share the space 
to "client" machines.  However, the IETD iSCSI Target seems pretty 
solid, so I'm not really concerned about that.

> Well, that's the fault of either iSCSI or GNBD. md/raid1 over nbd works 
> flawlessly in this scenario on 2.6 kernels (for 2.4, you'll need a 
> special patch -- ask me for it, if you want).

Yeah, I fixed that problem (at least with iSCSI - haven't tried with 
GNBD).  It was a PEBKAC issue :).
