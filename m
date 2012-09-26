From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two
 disks, causing silent data corruption
Date: Wed, 26 Sep 2012 09:59:42 +0100
Message-ID: <5062C3FE.7090906@yuiop.co.uk>
References: <50606207.7040804@gooseman.cz> <20120925141959.0c22de7d@notabene.brown> <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se> <152edbf7bdad33717477f174f94116b7@192.168.93.35> <20120925223227.130ef8e3@notabene.brown> <50628B39.90205@gooseman.cz> <20120926154107.1568a115@notabene.brown> <20120926082848.GA18616@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926082848.GA18616@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: NeilBrown <neilb@suse.de>, Jakub Hus?k <jakub@gooseman.cz>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/09/2012 09:28, keld@keldix.com wrote:
[...]
> I also understand it now, I think. raid10,f2 with 4 disks cannot in the current implementation
> survive 2 failing disks.

It can, but only two non-adjacent discs. With 4 drives sda-sdd, than 
means you can only lose both sda and sdc, or sdb and sdd.

> We have discussed earlier how to implement raid10,far that would mean
> better survival chances with more disks failing. This is not implemented yet.

No, but even if/when it is, there will still be some combinations of two 
discs that you cannot afford to lose. The layout change to try to 
improve redundancy will not be generic, as it doesn't work for an odd 
number of discs, so the existing layout would have to be retained as an 
option.

Cheers,

John.

-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
