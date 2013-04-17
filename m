From: David Brown <david.brown@hesbynett.no>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 11:26:10 +0200
Message-ID: <516E6AB2.3050701@hesbynett.no>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <alpine.DEB.2.00.1304161905150.23668@uplift.swm.pp.se> <516DAE0E.5080209@hesbynett.no> <alpine.DEB.2.00.1304170952280.23668@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304170952280.23668@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/04/13 09:56, Mikael Abrahamsson wrote:
> On Tue, 16 Apr 2013, David Brown wrote:
> 
>> you are going to have terrible RMW performance for small writes. 
>> However, as
> 
> As I said, I don't have problem with lower performance. My workload is
> write once and few, read many. If the performance is approximately the
> approximately the same as a 10 drive RAID-6, but with double the
> storage, I'm fine.

I would expect read performance for triple-parity raid to be similar to
Raid5 or Raid6 - i.e., you get good striped performance, especially for
large files as they are spread over many spindles.  Of course, since
triple-parity md raid does not yet exist, that's just theoretical...

> 
>> I am not sure there is much real-world need of triple parity raid for
>> normal arrays - even with better cpu scaling, it would still be a lot
>> slower than two raid6 arrays LVM'ed together.  I foresee it's main use
>> as a temporary measure during array maintenance.  For example, if you
>> have a raid6 and you want to swap out the drives for bigger ones, then
>> you could temporarily add an extra drive for a third parity using a
>> non-symmetrical layout.  Once this extra drive is synced, then you can
>> step through the other drives doing a replace-and-resync, knowing that
>> you still have the double parity safety. Then at the end of the
>> process you drop the third parity again.
> 
> Well, I run RAID6+spare. I'd rather run a triple parity drive unless the
> write performance penalty is huge.
> 

It's encouraging to hear people are interested in this.  But before it
can be implemented, there has to be someone with an understanding of
Linux md raid who can implement it.  I know the maths involved, but I
have no experience with Linux kernel work (I work with embedded systems
- while I use the same programming language as the kernel, it's a very
different style of programming).

