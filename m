From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 07:11:55 -0600
Message-ID: <4D1C851B.3040304@hardwarefreak.com>
References: <20101230082356.GC2986@bitwizard.nl> <4D1C470E.4080406@crc.id.au> <20101230094230.GE2986@bitwizard.nl> <4D1C616D.8030904@hardwarefreak.com> <4D1C73D4.6050600@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1C73D4.6050600@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson put forth on 12/30/2010 5:58 AM:
> On 30/12/2010 10:39, Stan Hoeppner wrote:
> [...]
>> Any RAID scheme that uses parity is less than optimal, and up to
>> horrible, for heavy random IO loads.  As always, this depends on "how
>> heavy" the load is.  For up to a few hundred constant IOPS you can get
>> away with parity RAID schemes.  If you need a few thousand or many
>> thousand IOPS, better stay away from parity RAID.
> 
> Sorry, I have to disagree with this, in this situation. RAID-6 over 4
> discs will be just as fast for reading multiple small files as RAID-10
> over 4 discs, and a web server is a read-mostly environment, while at
> the same time I can't imagine any RAID schema ever giving thousands of
> IOPS over 4 discs, parity or no.

That's because you apparently didn't learn about paragraph's in English
class:  http://en.wikipedia.org/wiki/Paragraph  Do you Brits use
paragraphs differently than we do here in the states?

My first paragraph dealt with general performance of parity vs non
parity RAID WRT high IO loads.  My second paragraph covered the downside
of the redundancy methods of RAID 3/4.  My third paragraph dealt
specifically with Roger's web server.

Note that nothing in my first paragraph mentioned a web server workload.
 Also note that nowhere did I mention a count of 4 drive, nor commented
regarding the suitability of any RAID level with 4 drives.

Also note there were two "situations" mentioned by Roger.  The first
referenced a previous thread which dealt with a high transaction load
server similar to a mail server, IIRC.  My first paragraph related to
that.  The second "situation", to which you refer, dealt with Roger's
web server.

-- 
Stan
