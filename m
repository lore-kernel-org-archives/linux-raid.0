From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 12:04:34 -0400
Message-ID: <428E0A92.3060108@steeleye.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>	 <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>	 <17029.12773.197506.463977@cse.unsw.edu.au>	 <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com>	 <17037.35615.456231.737766@cse.unsw.edu.au> <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Doug,

Doug Ledford wrote:
> On Fri, 2005-05-20 at 17:00 +1000, Neil Brown wrote:

>>There is a converse to this.  People should be made to take notice if
>>there is possible data corruption.
>>
>>i.e. if you have a system crash while running a degraded raid5, then
>>silent data corruption could ensue.  mdadm will currently not start
>>any array in this state without an explicit '--force'.  This is somewhat
>>akin to fsck sometime requiring human interaction.  Ofcourse if there
>>is good reason to believe the data is still safe, mdadm should -- and
>>I believe does -- assemble the array even if degraded.
> 
> 
> Well, as I explained in my email sometime back on the issue of silent
> data corruption, this is where journaling saves your ass.  Since the
> journal has to be written before the filesystem proper updates are
> writting, if the array goes down it either is in the journal write, in
> which case you are throwing those blocks away anyway and so corruption
> is irrelevant, or it's in the filesystem proper writes and if they get
> corrupted you don't care because we are going to replay the journal and
> rewrite them.

I think you may be misunderstanding the nature of the data corruption 
that ensues when a system with a degraded raid4, raid5, or raid6 array 
crashes. Data that you aren't even actively writing can get corrupted. 
For example, say we have a 3 disk raid5 and disk 3 is missing. This 
means that for some stripes, we'll be writing parity and data:

disk1   disk2   {disk3}

  D1       P      {D2}

So, say we're in the middle of updating this stripe, and we're writing 
D1 and P to disk when the system crashes. We may have just corrupted D2, 
which isn't even active right now. This is because we'll use D1 and P to 
reconstruct D2 when disk3 (or its replacement) comes back. If we wrote 
D1 and not P, then when we use D1 and P to reconstruct D2, we'll get the 
wrong data. Same goes if we wrote P and not D1, or some partial piece of 
either or both.

There's no way for a filesystem journal to protect us from D2 getting 
corrupted, as far as I know.

Note that if we lose the parity disk in a raid4, this type of data 
corruption isn't possible. Also note that for some stripes in a raid5 or 
raid6, this type of corruption can't happen (as long as the parity for 
that stripe is on the missing disk). Also, if you have a non-volatile 
cache on the array, as most hardware RAIDs do, then this type of data 
corruption doesn't occur.

--
Paul
