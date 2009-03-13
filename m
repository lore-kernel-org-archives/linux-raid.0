From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 14:48:31 +0000
Message-ID: <49BA723F.8020905@anonymous.org.uk>
References: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/03/2009 23:46, Ryan Wagoner wrote:
[...]
> Both systems exhibit the same issues on the RAID 1 drives. That rules
> out the drive brand and controller card. During any IO intensive
> process the IO wait will raise and the system load will climb.

I'm sorry if this sounds flippant, but what did you expect?

> I've
> had the IO wait as high as 70% and the load at 13+ while migrating a
> vmdk file with vmware-vdiskmanager. You can easily recreate the issue
> with bonnie++.
> 
> I can perform the same disk intensive operation on the RAID 5 array
> with almost no io wait or load. What is the deal with this? Is there
> something I can tweak?

I suspect your RAID-5 array has higher thoughput available - reading and 
writing across 3 discs rather than 2 - and what you're doing isn't quite 
maxing out its throughput, whereas it does on the 2-disc RAID-1. I 
imagine you would see the same thing on a single disc.

Bear in mind that iowait time needn't be wasted; run a few copies of 
something CPU intensive at the same time and you will see zero iowait.

High system load isn't necessarily a problem either; I once had a busy 
web server where the system load went from about 5 one day to over 200 
the next. Cue much panicking trying to find out what had happened. 
Turned out the web designers had made the home page 70K instead of 60K, 
so a lot of httpd processes sending to slow links were stalled when 
previously the whole lot would have been in network buffers. It still 
worked fine in that there was no detectable performance problem, it was 
just an alarming-looking system load.

Cheers,

John.

