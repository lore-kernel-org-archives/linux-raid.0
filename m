From: joystick <joystick@shiftmail.org>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Wed, 07 Nov 2012 10:55:53 +0100
Message-ID: <509A3029.4050402@shiftmail.org>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se> <20121105162227.7bc5c103@notabene.brown> <5099BC6B.7030500@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5099BC6B.7030500@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: NeilBrown <neilb@suse.de>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/12 02:42, Brad Campbell wrote:
> On 05/11/12 13:22, NeilBrown wrote:
>
> I have a test system set up at the moment with a RAID10 n,2 across 6 
> 1TB drives + 2 spares.
>
> I've run several hot-replace tests using 3.6.2 and found it works as 
> advertised.
>
> I also have two drives with hard write errors (excellent for failure 
> testing), and trying to replace a drive with one that contains a write 
> error fails the replace as you would expect.

Thanks for your testing Brad

we still need someone to test the other case, a more common scenario I'd 
say: the disk to be replaced fails during hot-replace

> The test machine is on UPS, so I have not done any testing that 
> involves reboots during a re-sync.

And also this one...
Best simulation would be unpulling the plug so that disks do not flush
if you have still time for us, of course :-)

Thank you
