From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 21 Mar 2005 11:07:06 -0500
Message-ID: <423EF12A.4030207@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <qehtg2-6c1.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Paul Clements <paul.clements@steeleye.com> wrote:
> 
>>Peter T. Breuer wrote:
>>
>>>I don't see that this solves anything. If you had both sides going at
>>>once, receiving different writes, then you are sc&**ed, and no
>>>resolution of bitmaps will help you, since both sides have received
>>>different (legitimate) data. It doesn't seem relevant to me to consider 
>>
>>You're forgetting that journalling filesystems and databases have to 
>>replay their journals or transaction logs when they start up.

All I'm saying is that in a split-brain scenario, typical cluster 
frameworks will make two (or more) systems active at the same time. This 
is not necessarily fatal, because as you pointed out, if only one of 
those systems (let's call it system A) is really available to the 
outside world then you can usually simply trust the data on A and use it 
to sync over the other copies. But, if system B brought up a database or 
journalling FS on its copy of the data, then there were writes to that 
disk that have to be synced over. You can't simply use the bitmap on 
system A; you have to combine them (or else do a full resync).

>>>What about when A comes back up? We then get a 
>>>
>>>                 .--------------.
>>>        system A |    system B  |
>>>          nbd ---'    [raid1]   |
>>>          |           /     \   |
>>>       [disk]     [disk]  [nbd]-'
>>>
>>>situation, and a resync is done (skipping clean sectors). 
>>
>>You're forgetting that there may be some data (uncommitted data) that 
>>didn't reach B that is on A's disk (or even vice versa).
> 
> 
> You are saying that the journal on A (presumably not raided itself?) is
> waiting to play some data into its own disk as soon as we have finished
> resyncing it from B? I don't think that would be a good idea at all.

No, I'm simply saying this: when you fail over from system A to system B 
(say you lost the network or system A died), there is some amount of 
data that could be out of sync (because raid1 submits writes to all 
disks simultaneously). When you take over using the data on system B, 
you're presumably going to want to (at some point) get A back to a state 
where it has the latest data (in case B later fails or in case A is a 
better system and you want to make it active, instead of B). To do that, 
you can't simply take the bitmap from B and sync back to A. You've got 
to look at the old bitmap on A and combine it with B's bitmap (or you've 
got to do a full resync). Until you've done that, the data that is on A 
is worthless.
