From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 14:43:56 -0500
Message-ID: <423B2F7C.3030907@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <23krg2-4rr.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Paul Clements <paul.clements@steeleye.com> wrote:

> I don't see that this solves anything. If you had both sides going at
> once, receiving different writes, then you are sc&**ed, and no
> resolution of bitmaps will help you, since both sides have received
> different (legitimate) data. It doesn't seem relevant to me to consider 

You're forgetting that journalling filesystems and databases have to 
replay their journals or transaction logs when they start up.


> What about when A comes back up? We then get a 
> 
>                  .--------------.
>         system A |    system B  |
>           nbd ---'    [raid1]   |
>           |           /     \   |
>        [disk]     [disk]  [nbd]-'
> 
> situation, and a resync is done (skipping clean sectors). 

You're forgetting that there may be some data (uncommitted data) that 
didn't reach B that is on A's disk (or even vice versa). That is why 
you've got to retrieve the bitmap that was in use on A and combine it 
with B's bitmap before you resync from B to A (or do a full resync).

--
Paul
