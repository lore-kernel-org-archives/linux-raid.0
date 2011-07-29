From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Fri, 29 Jul 2011 11:30:33 -0400
Message-ID: <4E32D219.503@redhat.com>
References: <4E25C9BA.1060401@dodtsair.com> <CABYL=TppzPDszVp3cr0DnuVDAg3Hjq2dvZyP0CYEz2x3H2ZjZQ@mail.gmail.com> <4E31AB58.3030206@redhat.com> <CABYL=To6GFBwsHi_2y6Rzgvr3LbP2Z9hUN8QjYP5Wf+vJtKsXw@mail.gmail.com> <4E32B5FE.6050001@redhat.com> <j0uhk8$k9a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j0uhk8$k9a$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/29/2011 10:55 AM, David Brown wrote:
> One thing has occurred to me while reading this thread - it seems to be
> an assumption here that SSD's are faster than HD's. In one area - access
> times - SSD's are very much faster. But when transferring bulk data,
> they are not necessarily faster.

Not necessarily, no.  But, if you do like I did and pick your SSD 
carefully, they are.  I specifically chose the one I did because it was 
SATA-III with a 6MB/s link speed and it was rated for 400+MByte/s reads 
and 210MByte/s writes.  Here's the link:

http://www.newegg.com/Product/Product.aspx?Item=N82E16820233154

There are even faster ones out there now.

But, I was worried about the drive wearing out under the frequent 
checkouts, builds, etc. so hence the reason I have two hard drives 
backing it up.  When it does wear out, I'll put a new one in, add it to 
the array, wait for resync, all done.

> Certainly a pair of good hard disks in
> RAID10,far will stream reads and writes with a similar throughput to
> many SSD's. An ideal situation is therefore that small reads will come
> from the SSD, but that bulk reads could come from any disk that is
> currently idle. Enabling "write-behind" on the hard disks would still be
> a big gain on the write latency.


