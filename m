From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 15:34:32 +0300
Message-ID: <423C1C58.1090609@tls.msk.ru>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <9phtg2-6c1.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
[]
>>o For md, all drives are equal, that is, for example, raid1
>>  code will balance reads among all the available drives a-la
> 
> Not necessarily so. At least part of the FR1 patch is dedicated to
> timing the latencies of the disks, and choosing the fastest disk to
> read from.
[]
>>o We all know how md "loves" to kick off "faulty" array components
>>  after first I/O error, don't we?  DRBD allows "temporary" failures
> 
> Again, the FR1 patch contains the "Robust Read" subpatch, which stops
> this happening. It's not a patch that intersects with the bitmap
> functionality at all, by the way.
[]
> 
> Well, so will FR1 (at least when run over ENBD, because FR1 contains
> a machanism that allows the disks to tell it when they have come back
> into their full gleam of health again).

Ok, you intrigued me enouth already.. what's the FR1 patch?  I want
to give it a try... ;)  Especially I'm interested in the "Robust Read"
thing...

/mjt
