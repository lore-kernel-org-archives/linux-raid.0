From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: write only raid1
Date: Wed, 10 Nov 2004 10:56:36 -0500
Message-ID: <41923A34.5000709@steeleye.com>
References: <1100096418.3190.4.camel@localhost.localdomain>	 <41922E3E.7050206@steeleye.com> <1100101541.3190.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1100101541.3190.51.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ming Zhang wrote:
> On Wed, 2004-11-10 at 10:05, Paul Clements wrote:
> 
>>Ming Zhang wrote:
>>
>>
>>>is there any technical issue that lead not to be implemented?
>>
>>No. In fact, it has been implemented. Both Peter T. Breuer and I have 
>>come up with slightly different patches to implement the write only 
>>functionality.
>>
> 
> can u send me the patch then i can have a look?

my patches are here:

http://parisc-linux.org/~jejb/md_bitmap/

you're looking for the async write portion of the code, which has the 
write-only functionality in it (later patches do not contain that code, 
so look at the older ones)

check the mailing list archives for discussion

Peter's patch is here:

http://marc.theaimsgroup.com/?l=linux-raid&m=109238533827986&w=2


--
Paul
