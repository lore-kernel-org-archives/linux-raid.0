From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 02:02:39 +0400
Message-ID: <41DB127F.3090303@wasp.net.au>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j6dra2-9vs.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:

>>You can't flip a bit 
>>unnoticed. 
> 
> 
> Not by me, but then I run md5sum every day. Of course, there is a
> question if the bit changed on disk, in ram, or in the cpu's fevered
> miscalculations. I've seen all of those. One can tell which after a bit
> more detective work.
> 

I'm wondering how difficult it may be for you to extend your md5sum script to diff the pair of files 
and actually determine the extent of the corruption. bit/byte/word/.../sector/.../stripe wise?

I have 2 RAID-5 arrays here. a 3x233GiB and a 10x233GiB and I when I install new data on the drives 
I add the md5sum of that data to an existing database stored on another machine. This gets compared 
against the data on the arrays weekly and I have yet to see a silent corruption in 18 months.

I do occasionally remove/re-add a drive to each array, which causes a full resync of the array and 
should show up any parity inconsistency by a faulty fsck or md5sum. It has not as yet.

Honestly, in my years running Linux and multiple drive arrays I have never experienced errors such 
as you are getting.

Oh.. and both my arrays are running ext3 with an internal journal (as are all my other partitions on 
all my other machines).

Perhaps I'm lucky?

Brad
