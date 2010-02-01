From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: unknown partition table starting with 2.6.28
Date: Mon, 01 Feb 2010 15:46:38 -0500
Message-ID: <4B673DAE.3040806@tmr.com>
References: <4B51010E.9090800@vorgon.com> <4B51B46A.4080302@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B51B46A.4080302@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson wrote:
> On 15/01/2010 23:58, Timothy D. Lenz wrote:
>> I am trying to update my kernel from 2.6.26.8 to the current .32. 
> [...]
>> Starting with .28 I am getting an error about unknown partition table 
>> for all 3 md's. md0 is boot and main programs, md1 is swap, md2 is 
>> mostly recordings storage for vdr. All 3 are raid 1 and raid is built 
>> in.
>
> Your md devices aren't partitioned so you can quite safely ignore the 
> warning. See also http://marc.info/?l=linux-raid&m=125797242110594&w=2

To clarify that a bit, the kernel can use several partition formats, and 
something in the partitions looks like a partition table but not a 
*valid* partition table. So the kernel warns that it doesn't recognize 
the table.

I suspect that using a different superblock type would change (probably 
eliminate) this, putting the md information at the start of the 
partition, of in a bit or whatever makes the kernel happy. The kernel 
would make us happy if it checked for a valid md superblock at the *end* 
of the partition, but there may be reasons why that's undesirable.

Finally, I'm less willing than John to say you can ignore it, any time 
something comes close enough to working (in an undesired way) to 
generate an error message, if there's a simple way to be sure the kernel 
doesn't try to use random data as a partition table, you might well want 
to take a step to prevent a problem now.

I believe it arises out of all arrays being partitionable recently, 
again the details don't come to mid, I've been pretty head down on 
another project since November.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

