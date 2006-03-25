From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Silly stripe cache values
Date: Sat, 25 Mar 2006 15:34:38 +0400
Message-ID: <44252ACE.9020706@wasp.net.au>
References: <442528D7.1050302@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442528D7.1050302@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brad Campbell wrote:
> G'day all,
> 
> I have a box here.. it has a 2Ghz processor and 1.5GB of ram. It runs 
> the entire OS over NFS and it's sole purpose in life is to run 15 SATA 
> drives in a Raid-6 with ext3 on it, and share that over NFS. Most of 
> that ram is sitting completely idle and thus I thought a logical thing 
> to do would be to stuff as much of it as possible into the MD subsystem 
> to help it cache..
> 
> Are there any limits to the values living in /sys/block/md* and what 
> might be the tradeoffs (if any) to using what would normally be thought 
> stupid amounts of ram for these knobs ?
> 
> This box does not get written to often, it's just a media streamer 
> mostly.. but if I am writing to it then it chokes just providing a 1Mb 
> stream over the network currently. (It's on a 2.6.15-git11 kernel 
> currently but I'm just upgrading to 2.6.16 now)

Scratch that.. the limit appears to be 32768 and that works fine..

Google search results increase in accuracy proportionally with the elapsed time of a list posting 
with the question.. :\

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
