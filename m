From: Peb <peb-misc@peeble.net>
Subject: Re: md array numbering is messed up
Date: Tue, 31 Oct 2006 00:50:01 +0100
Message-ID: <45468FA9.4010303@peeble.net>
References: <45451A4C.9010708@peeble.net>
 <17733.7315.357603.311275@cse.unsw.edu.au> <4545DECE.7030705@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4545DECE.7030705@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, dean@arctic.org, brad@wasp.net.au
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Neil Brown wrote:
>> On Sunday October 29, peb-misc@peeble.net wrote:
>>> Hi,
>>>
>>> I have 2 arrays whose numbers get inverted, creating havoc, when booting
>>> under different kernels.
>>>
>>> I have md0 (raid1) made up of ide drives and md1 (raid5) made up of five
>>> sata drives, when booting with my current ubuntu 2.6.12-9 kernel. When I
>>> try to boot a more recent kernel (2.6.15-26 or 2.6.15-27) the
>>> order is inversed and my sata raid5 array shows up as md0.
>>>
>>> My arrays are part of evms volumes that just stop working if the
>>> numbering is inverted.
>>>
>>> any clues ?
>> Your arrays are being started the wrong way.
>> Do you have an mdadm.conf that lists the arrays?  Can you show us what
>> it looked like?
>> If not, do you know how the arrays are started in ubuntu?
> 
> My guess is that it's using mdrun shell script - the same as on Debian.
> It's a long story, the thing is quite ugly and messy and does messy things
> too, but they says it's compatibility stuff and continue shipping it.
> 
> For the OP, the solution is to *create* mdadm.conf file - in that case
> mdrun should hopefully NOT run.
> 
> /mjt

Well I have the following mdadm.conf:

DEVICE /dev/hda /dev/hdc /dev/sd*
ARRAY /dev/md1 level=raid5 num-devices=4 UID=8ed64073:04d21e1c:33660158:
a5bc892f
ARRAY /dev/md0 level=raid1 num-devices=2 UID=cab9de58:d20bffae:654d1910:
6f440136

I 've tried inverting the two ARRAY lines and placing the sd* device
before the ide drives, but that didn't change anything.

So I guess my mdadm.conf isn't correct since mdrun is still running even
though the file exists ???

--
Peb
