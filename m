From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Mon, 26 Feb 2007 10:02:24 +1300
Message-ID: <45E1F960.4090603@sauce.co.nz>
References: <1172258378.21648.51.camel@cowie>  <45DF46B7.3040707@maine.edu> <1172406243.3765.29.camel@cowie> <45E1E051.1020908@sauce.co.nz> <Pine.LNX.4.64.0702251504090.21918@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702251504090.21918@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mark Hahn wrote:

> is it known what a long self-test does?  for instance, ultimately you
> want the disk to be scrubbed over some fairly lengthy period of time.
> that is, not just read and checked, possibly with parity "fixed",
> but all blocks read and rewritten (with verify, I suppose!)

The smartctl man page is a little vague, but it looks like it does no 
writing.


Paraphrasing somewhat:

short selftest - The  "Self"  tests check  the  electrical and 
mechanical performance as well as the read performance of the disk.

long selftest - This is a  longer  and  more  thorough version  of the 
Short Self Test described above.

Richard
