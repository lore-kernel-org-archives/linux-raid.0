From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 12:03:43 -0500
Message-ID: <423B09EF.8070708@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <7e6rg2-pj1.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Lars Marowsky-Bree <lmb@suse.de> wrote:
> 
>>On 2005-03-18T13:52:54, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

>>The problem is for multi-nodes, both sides have their own bitmap. When a
>>split scenario occurs,

> Here I think you mean that both nodes go their independent ways, due to
> somebody tripping over the network cables, or whatever.

Yes, or just a failover, where the active system crashes or is taken 
down (while the bitmap is dirty).


>>and both sides begin modifying the data, that
>>bitmap needs to be merged before resync, or else we risk 'forgetting'
>>that one side dirtied a block.

Right. And eventually we'd like to have that capability (of recombining 
bitmaps).


> Could you set out the scenario very exactly, please, for those of us at
> the back of the class :-). I simply don't see it. I'm not saying it's
> not there to be seen, but that I have been unable to build a mental
> image of the situation from the description :(.

Typically, in a cluster environment, you set up a raid1 with a local 
disk and an nbd (or one of its variants) below it:

    [raid1]
    /     \
[disk]  [nbd] ---------> other system


The situation he's talking about is, as you put it "somebody tripping 
over the network cables".

In that case, you'll end up with this:

    system A       system B
    [raid1]        [raid1]
    /     \        /     \
[disk]  [XXX]  [disk]  [XXX]


Where there's a degraded raid1 writing only to the local disk on each 
system (and a dirty bitmap on both sides).

The solution is to combine the bitmaps and resync in one direction or 
the other. Otherwise, you've got to do a full resync...

--
Paul
