From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: migrating raid-1 to different drive geometry ?
Date: Tue, 25 Jan 2005 08:22:07 +0000
Message-ID: <ct4vhu$c62$1@sea.gmane.org>
References: <20050124145910.GC29766@kaneda> <16885.31484.125772.316987@cse.unsw.edu.au> <ct447m$l90$1@sea.gmane.org> <41F598BC.3040805@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41F598BC.3040805@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Hardy wrote:
> 
> I'd missed the mdadm --grow feature as well, so I checked into it.
> 
> It is only capable of increasing size on raid5, not component count. The 
> specific use case used as an example is that you slowly retire component 
> drives and the replacements are larger. When all components are the 
> larger size, you can grow the raid5 array to use the full size of the 
> device, followed by a filesystem expansion to use the grown array.
> 
> That makes sense, given the disk layout of raid5 - its not hard to add 
> more stripes on the end of components, but adding new components 
> requires each stripe to change significantly.
> 
> To grow component count on raid5 you have to use raidreconf, which can 
> work, but will toast the array if anything goes bad. I have personally 
> had it work, and not work, in different instances. The failures were not 
> necessarily raidreconf's fault, but its not fault tolerant is the point, 
> as it starts at the first stripe, laying things out the new way, and if 
> it doesn't finish, and finish correctly, you are in an irretrievable 
> inconsistent state.
> 

Bah, too bad.

I don't need it yet, but at some stage I'd like to be able to add 
another 250GB drive(s) to me array and grow the array to use the 
additional space in a safe/failsafe way.

Perhaps by the time I come to need it this might be possible?

R.
-- 
http://robinbowes.com

