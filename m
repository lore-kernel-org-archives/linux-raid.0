From: Brad Campbell <brad@wasp.net.au>
Subject: Re: 3 disk raid-5 without parity
Date: Mon, 14 Jun 2004 15:28:56 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40CD8BF8.5040601@wasp.net.au>
References: <20040614111920.GA17785@middle.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040614111920.GA17785@middle.of.nowhere>
To: Jurriaan <thunder7@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jurriaan wrote:
> I am trying to convince my boss our new database-server wants raid-0+1,
> not raid-5, and I got an idea while reading endless articles about
> raid-5 being slow when writing and management not listening.
> 
> suppose you make a 3-disc raid-5 without parity:
> 
> data    disc1 disc2 disc3
> A       A     A     B
> B       B     C     C
> 
> How would that perform compared to raid-5 and raid-0+1?
> 
> As I understand, the performance problem with raid-5 when writing is
> that you may need to read old data to recompute the parity block, and
> the write the parity block and the data in parallel.
> 
> So in this case, you can read straight away from all 3 disks (with
> raid-5 one of the disks will have parity information) and you can write
> without reading old data.

What you propose is not quite raid-5, but appears to be a striping hybrid between raid-0 and raid-1.
If I get what you are saying, you are writing each block twice, and ensuring each block is written 
to at least 2 different drives. Interesting idea, but not really efficient. In addition, you are 
doubling your write bandwidth requirements (not unlike pure raid-1).

Yes, raid-5 random write performance is limited by read-modify-write cycles when they are required. 
The raid-5 md driver does do a pretty good job of avoiding this where possible though.

I have not really benchmarked my raid-5 write performance, but on reads I sit around 90MB/s across 
my 10 drives. (Even my SATA raid-0 with 2 7200RPM drives has trouble getting much quicker than this 
as I keep saturating the PCI bus)

Regards,
Brad
