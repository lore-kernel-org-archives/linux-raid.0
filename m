From: Mike Hardy <mhardy@h3c.com>
Subject: Re: migrating raid-1 to different drive geometry ?
Date: Mon, 24 Jan 2005 16:54:20 -0800
Message-ID: <41F598BC.3040805@h3c.com>
References: <20050124145910.GC29766@kaneda> <16885.31484.125772.316987@cse.unsw.edu.au> <ct447m$l90$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ct447m$l90$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'd missed the mdadm --grow feature as well, so I checked into it.

It is only capable of increasing size on raid5, not component count. The 
specific use case used as an example is that you slowly retire component 
drives and the replacements are larger. When all components are the 
larger size, you can grow the raid5 array to use the full size of the 
device, followed by a filesystem expansion to use the grown array.

That makes sense, given the disk layout of raid5 - its not hard to add 
more stripes on the end of components, but adding new components 
requires each stripe to change significantly.

To grow component count on raid5 you have to use raidreconf, which can 
work, but will toast the array if anything goes bad. I have personally 
had it work, and not work, in different instances. The failures were not 
necessarily raidreconf's fault, but its not fault tolerant is the point, 
as it starts at the first stripe, laying things out the new way, and if 
it doesn't finish, and finish correctly, you are in an irretrievable 
inconsistent state.

raid1 can grow components with mdadm --grow though.

Cool trick

-Mike

Robin Bowes wrote:
> Neil Brown wrote:
> 
>> If you are using a recent 2.6 kernel and mdadm 1.8.0, you can grow the
>> array with
>>    mdadm --grow /dev/mdX --size=max
> 
> 
> Neil,
> 
> Is this just for RAID1? OR will it work for RAID5 too?
> 
> R.
