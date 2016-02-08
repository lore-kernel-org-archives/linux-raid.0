From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Best option for SSD caching on a md raid array?
Date: Mon, 08 Feb 2016 13:21:25 -0700
Message-ID: <4411310.rejlojhIFS@nell>
References: <1670804.QnHtKWfib8@nell> <56B85390.9050505@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B85390.9050505@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon Feb 8 2016 09:36:32 AM you wrote:
> Hi,
> 
> If the server is going to have reasonably long uptimes, then lots of ram
> could easily be a better choice than an SSD caching system.  I don't
> know how you are planning your "dual raid5 array", nor what sort of VM's
> you are dealing with.  But the key point of an SSD cache is to get fast
> access to common data with random access patterns, since a raid array
> will give you plenty of bandwidth for large serial accesses.  And while
> an SSD is fast for random reads, having the data in the server's cache
> is even faster.

Basically I have two servers, one is an older single socket xeon e3 with 16GB 
ram, that tops out at 32GB IIRC (if i can find reasonably priced non buffered 
8GB ddr3 ecc DIMMs). And my other box is a dual socket 32 core (2x16) Opteron 
box with about 120GB ram.

I'm planning on having each machine have a storage array that are synced using 
DRBD or something similar. The idea is to allow online migration with little 
fuss, not having to access storage over the network, and have what is 
essentially a raid 1 on top of the raid5 on each machine.

The Xeon box has a fair bit less resources (except per core perf is probably 
better), and may have issues caching things in ram.

The main use case of both machines is to host various services, like a couple 
game servers, plex, gitlab, unifi controller, testing/staging instances for 
various services for work. Also a couple windows vms.

So its a mix of things.

> On 08/02/16 06:14, Thomas Fjellstrom wrote:
> > Hi,
> > 
> > I'm planning on setting up a dual raid5 array for hosting vm's off LVM, I
> > would like to add an ssd cache to help with typical server system loads,
> > and some mixed read/write loads for game servers.
> > 
> > I'm wondering what the "best" route for me to go is. There's a few options
> > that I know of, like flashcache, dm-cache, and bcache. The question is
> > which of those is better suited to my use case?
> > 
> > Also wondering which ones people here use, and what they use it for.
> > 
> > Thanks!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

