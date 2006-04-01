From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Sat, 01 Apr 2006 04:28:30 +0400
Message-ID: <442DC92E.8080003@wasp.net.au>
References: <442BFB2B.6090903@stams.strath.ac.uk> <442D22CD.3010602@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442D22CD.3010602@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Smith wrote:
> Ian Thurlbeck wrote:
>>
>> Dear All
>>
>> I have 4x500GB Maxtor SATA drives and I want to attach
>> these to a 4-port SATA PCI card and RAID5 them using "md"
>>
>> Could anybody recommend a card that will have out of
>> box support on a Fedora system ?
> 
> I have had a lot of success with Promise TX4 cards, with the caveat that 
>  more than two controllers can't be in the same box (or couldn't as of a 
> few months ago - this may have been fixed).  They're fairly cheap and 

I've been running 3 together in one box for about 18 months, and four in another for a year now... 
the on board BIOS will only pickup 8 drives, but they work just fine under Linux and recognise all 
connected drives.

I have 11 drives in one box (on promise.. 2 on the on-board VIA and 1 on PATA) and 15 drives in 
another (all across 4 promise cards).. all on SATA150-TX4 cards..

Performance sucks.. but then when you put 15 drives on a single PCI 33Mhz bus what do you expect ?
Great for streaming media though.. (and cheap, and very reliable). The only media errors I get are 
on the VIA controller. The promise controllers have not had a single media error since they were 
installed.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
