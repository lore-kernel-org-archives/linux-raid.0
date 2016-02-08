From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best option for SSD caching on a md raid array?
Date: Mon, 08 Feb 2016 09:36:32 +0100
Message-ID: <56B85390.9050505@hesbynett.no>
References: <1670804.QnHtKWfib8@nell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1670804.QnHtKWfib8@nell>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

If the server is going to have reasonably long uptimes, then lots of ram
could easily be a better choice than an SSD caching system.  I don't
know how you are planning your "dual raid5 array", nor what sort of VM's
you are dealing with.  But the key point of an SSD cache is to get fast
access to common data with random access patterns, since a raid array
will give you plenty of bandwidth for large serial accesses.  And while
an SSD is fast for random reads, having the data in the server's cache
is even faster.


On 08/02/16 06:14, Thomas Fjellstrom wrote:
> Hi,
> 
> I'm planning on setting up a dual raid5 array for hosting vm's off LVM, I would 
> like to add an ssd cache to help with typical server system loads, and some 
> mixed read/write loads for game servers.
> 
> I'm wondering what the "best" route for me to go is. There's a few options 
> that I know of, like flashcache, dm-cache, and bcache. The question is which of 
> those is better suited to my use case?
> 
> Also wondering which ones people here use, and what they use it for.
> 
> Thanks!
> 

