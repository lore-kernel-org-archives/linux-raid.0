From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 0/3] md bitmap-based asynchronous writes
Date: Mon, 21 Mar 2005 11:31:51 -0500
Message-ID: <423EF6F7.2040201@steeleye.com>
References: <422F7621.8090602@steeleye.com>	<16949.5768.392061.95882@cse.unsw.edu.au>	<4239EDCA.4030502@steeleye.com> <16958.19415.701152.371199@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16958.19415.701152.371199@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday March 17, paul.clements@steeleye.com wrote:
> 
>>These three patches provide the ability to perform asynchronous writes 
>>with raid1. The asynchronous write capability is primarily useful when 
>>raid1 is employed in network replication (i.e., with one or more of the 
>>disks located on a remote system). It allows us to acknowledge writes 
>>before they reach the remote system, thus making much more efficient use 
>>of the network.

> However I would like to leave them until I'm completely happy with the
> bitmap resync, including
>   - storing bitmap near superblock  (I have this working)

Great. I assume you're using the 64k after the superblock for this 
(well, with v1 supers, I guess the bitmap could be just about 
anywhere?). So does this mean there would be multiple copies of the 
bitmap, or are you simply choosing one disk to which the bitmap is written?

>   - hot-add bitmap                  (I've started on this)

I assume this means the ability to add a bitmap to an active array that 
has no bitmap? Might it also include the ability to modify the bitmap 
(from userland) while the array is active, as this functionality is 
desirable to have (perhaps you followed the thread where this was 
discussed?).

>   - support for raid5/6 and hopefully raid10.  (still to come)

That would be nice too.

> and I would really like
>    only-kick-drives-on-write-errors-not-read-errors

Perhaps I can help out with this. I've seen the recent 
discussions/patches for this, but so far it doesn't look like we have a 
completely up-to-date/working/tested patch against the latest kernel, do 
we? So maybe I could do this (unless someone else is already)?

> to be the next priority.  After that, I will definitely look at async
> writes.

Great. Thanks.

--
Paul
