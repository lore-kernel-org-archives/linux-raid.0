From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Thu, 20 Mar 2008 15:19:08 +0100
Message-ID: <47E2725C.1020206@tuxes.nl>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080320134747.GA28114@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Theodore Tso <tytso@mit.edu>
List-Id: linux-raid.ids

Robin Hill wrote:
> On Thu Mar 20, 2008 at 02:32:37PM +0100, Bas van Schaik wrote:
>   
>> Anyone able to answer the last and most important question: does it
>> produce a message during resync in case of corruption? That would be great!
>>     
> There's no explicit message produced by the md module, no.  You need to
> check the /sys/block/md{X}/md/mismatch_cnt entry to find out how many
> mismatches there are.  Similarly, following a repair this will indicate
> how many mismatches it thinks have been fixed (by updating the parity
> block to match the data blocks).
>   
Marvellous! I naively assumed that the module would warn me, but that's
not true. Wouldn't it be appropriate to print a message to dmesg if such
a mismatch occurs during a check? Such a mismatch clearly means that
there is something wrong with your hardware lying beneath md, doesn't it?

> I've no idea whether the checkarray script you're using is checking this
> counter - there seems little point in having a special script if it
> isn't though.
>   
If I understand the meaning of this counter, it would be sufficient to
check the value of it _before_ the check operation and compare that
value to the counter value _after_ the check. If the counter has
increased: the check has encountered some inconsistencies which should
be reported.
Please correct me if I'm wrong!

Cheers,

  Bas
