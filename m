From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: question about the best suited RAID level/layout
Date: Fri, 05 Jul 2013 09:07:36 +0800
Message-ID: <51D61C58.2020207@fnarfbargle.com>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372978687.5249.52.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/07/13 06:58, Christoph Anton Mitterer wrote:

> I'd have even one more question here: Has anyone experience with my idea
> of intentionally running devices of different vendors (Seagate, WD,
> HGST)... for resilience reasons?... Does it work out as I plan, or are
> there any hidden caveats I can't see which make the resilience (not the
> performance) worse?

I've got both here. A large RAID-6 comprised entirely of single brand, 
single type consumer drives and a smaller RAID-10 built from a diverse 
selection. Both have had great reliability, so that's not really a good 
data point for you.

What I *have* found over the years is the importance of weeding out 
early failures. Before I commit a disk to service, I subject it to a 
couple of weeks of hard work. I usually knock up a quick and dirty bash 
script with multiple concurrent instances of dd reading and writing to 
differing parts of the disk simultaneously, with a bonnie++ run for good 
measure. With all this going on at the same time the drive mechanism 
gets a serious workout and the drive stays warmer than it will in actual 
service. If I have the chance, I do all the drives simultaneously and 
preferably in the machine they are going to spend the next couple of 
years. If I can't do that, then I have a burn-in chassis built from a 
retired server that can do 15 at a time.

This has proven quite effective in spotting the early life failures. I 
generally find (for consumer drives) if they pass this they'll last the 
3 years of 24/7 I use them for before I replace them. My enterprise 
drives are a different story, and I have some here with just over 38k 
hours on them. I'll probably replace them for bigger drives before they 
ever fail.

Regards,
Brad
