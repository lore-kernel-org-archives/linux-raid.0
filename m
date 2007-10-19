From: Michal Soltys <nozo@ziu.info>
Subject: chunk size (was Re: Time to deprecate old RAID formats?)
Date: Sat, 20 Oct 2007 00:43:32 +0200
Message-ID: <47193314.5010606@ziu.info>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org>	 <1192810534.1666.68.camel@firewall.xsintricity.com>	 <18200.56684.14194.630264@stoffel.org>	 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>	 <18200.57042.989520.666476@stoffel.org>	 <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>	 <1192813477.1666.74.camel@firewall.xsintricity.com>	 <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan> <1192814581.1666.87.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192814581.1666.87.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> course, this comes at the expense of peak throughput on the device.
> Let's say you were building a mondo movie server, where you were
> streaming out digital movie files.  In that case, you very well may care
> more about throughput than seek performance since I suspect you wouldn't
> have many small, random reads.  Then I would use a small chunk size,
> sacrifice the seek performance, and get the throughput bonus of parallel
> reads from the same stripe on multiple disks.  On the other hand, if I
> 

Out of curiosity though - why wouldn't large chunk work well here ? If you 
stream video (I assume large files, so like a good few MBs at least), the 
reads are parallel either way.

Yes, the amount of data read from each of the disks will be in less perfect 
proportion than in small chunk size scenario, but it's pretty neglible. 
Benchamrks I've seen (like Justin's one) seem not to care much about chunk 
size in sequential read/write scenarios (and often favors larger chunks). 
Some of my own tests I did few months ago confirmed that as well.
