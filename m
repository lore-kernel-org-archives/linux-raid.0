From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 18:10:48 +0000
Message-ID: <4D1CCB28.8030705@anonymous.org.uk>
References: <20101230082356.GC2986@bitwizard.nl> <4D1C470E.4080406@crc.id.au> <20101230094230.GE2986@bitwizard.nl> <4D1C616D.8030904@hardwarefreak.com> <4D1C73D4.6050600@anonymous.org.uk> <4D1C851B.3040304@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1C851B.3040304@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/12/2010 13:11, Stan Hoeppner wrote:
> John Robinson put forth on 12/30/2010 5:58 AM:
>> On 30/12/2010 10:39, Stan Hoeppner wrote:
>> [...]
>>> Any RAID scheme that uses parity is less than optimal, and up to
>>> horrible, for heavy random IO loads.  As always, this depends on "how
>>> heavy" the load is.  For up to a few hundred constant IOPS you can get
>>> away with parity RAID schemes.  If you need a few thousand or many
>>> thousand IOPS, better stay away from parity RAID.
>>
>> Sorry, I have to disagree with this, in this situation. RAID-6 over 4
>> discs will be just as fast for reading multiple small files as RAID-10
>> over 4 discs, and a web server is a read-mostly environment, while at
>> the same time I can't imagine any RAID schema ever giving thousands of
>> IOPS over 4 discs, parity or no.
>
> That's because you apparently didn't learn about paragraph's in English
> class:  http://en.wikipedia.org/wiki/Paragraph  Do you Brits use
> paragraphs differently than we do here in the states?

No, but apparently we use apostrophes correctly over here.

> My first paragraph dealt with general performance of parity vs non
> parity RAID WRT high IO loads.

Yes, and I suppose that I should have pointed out that the OP's friend 
had been given slightly inappropriate advice, since a web server doesn't 
do small file I/O like a mailserver. You expanded on a general situation 
which didn't apply, and the statement you made was wrong, or at least 
not correct in all circumstances.

>  My second paragraph covered the downside
> of the redundancy methods of RAID 3/4.

You were wrong again there: if you lose the parity disc in RAID 3/4 you 
don't lose the array, as the data discs are all still there. It is true 
that with modern huge (1TB+) drives where the error rate per bit read is 
still much the same as when drives were tiny (1GB+) that a recovery is 
much more risky than it used to be due to the dramatically increased 
chance of a second disc failing, but that is equally true of RAID 5.

>  My third paragraph dealt
> specifically with Roger's web server.

The third and the fourth; jolly good.

> Note that nothing in my first paragraph mentioned a web server workload.
>   Also note that nowhere did I mention a count of 4 drive, nor commented
> regarding the suitability of any RAID level with 4 drives.

No indeed, but that was the context of the question; why give entirely 
general advice when a specific usage applies?

> Also note there were two "situations" mentioned by Roger.  The first
> referenced a previous thread which dealt with a high transaction load
> server similar to a mail server, IIRC.

I see no such reference, apart from noting that "when asking for help, 
everybody pounced on us: - NEVER use raid5 for a server doing 
small-file-io like a mailserver. (always use RAID10)" which as I say is 
in my opinion inappropriate advice, since they're not trying to run a 
mailserver and won't have heavy random writes.

>  My first paragraph related to
> that.  The second "situation", to which you refer, dealt with Roger's
> web server.

I had surmised from the original question about using RAID-10, RAID-4 
etc that there was a desire to have more storage than a single drive 
mirrored twice, so I didn't think plain mirroring would suit, but 
perhaps that wasn't the intention and your solution would work.

Cheers,

John.

