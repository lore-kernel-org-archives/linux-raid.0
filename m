From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: possible bug in md
Date: Thu, 14 Jul 2011 12:17:37 -0400
Message-ID: <4E1F16A1.3000106@cdf.toronto.edu>
References: <4E11E9A6.2000606@cdf.toronto.edu>	<20110705102419.5f2b22fa@notabene.brown>	<4E133B03.60707@cdf.toronto.edu> <20110714151137.7cad2801@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110714151137.7cad2801@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On 07/14/11 01:11, NeilBrown wrote:
> I have made some changes to RAID10 so that it will not report that
> a device has failed when really it hasn't.  It will abort the recovery,
> ensure that another recovery doesn't automatically restart, and will
> report why the recovery was aborted.

Many thanks for taking care of that!

On a related note, do you know what would happen if on a 3-device RAID1 
(mirror), I failed one of the drives, and triggered a rebuild onto a 
spare, and then determined which device is the "source" for the rebuild, 
and yanked it out (or failed it)?

Would the RAID1 recover and start syncing from the next available (last 
remaining) valid device, or will it fail? If you don't know, I will 
conduct a test and report the result.

Cheers,
Iordan
