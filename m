From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: "Robust Read"
Date: Sat, 19 Mar 2005 23:20:11 +0300
Message-ID: <423C897B.1030100@tls.msk.ru>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es> <423C1C58.1090609@tls.msk.ru> <vvjtg2-t16.ln1@news.it.uc3m.es> <423C4E62.4070704@tls.msk.ru> <gj2ug2-9q3.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <gj2ug2-9q3.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>>[-- text/plain, encoding 7bit, charset: KOI8-R, 74 lines --]

Uh-oh.  Setting proper charset this time.  What a nonsense:
7bit but koi8... ;)

[]
> Uh OK. As I recall one only needs to count, one doesn't need a bitwise
> map of what one has dealt with.

Well.  I see read_balance() is now used to resubmit reads.  There's
a reason to use it instead of choosing "next" disk, I think.  There's
a reason to NOT use it too, as the "bitmap" will not be needed in
that case, only the counter.  Both will do the task ofcourse, and
the case wich requires only counter is preferred because it does
not restrict number of disks in the array the way "bitmap" does.

Ok, so be it the "map" variant when.. and it's even simpler that way.

[big snip]

> and then in the raid1d function:

BTW, what's the reason to use raid1d for retries in the first place?
Why not just resubmit the request in reschedule_retry() directly,
the same way it is done in raid1d?

[]
> Yes, I don't think you should muck with read_balance at all! It's an
> approach, but I don't think it's the right one. We just want to use the
> function to change target disks with here.  Why not reinstate the old
> "map" function which can do just that? Then no change to read_balancce
> is needed. Rename map() to remap() if it sounds better!

The key point is that there should be not many read errors.  Given said
that, I agree, simpler routine for retries is ok.

[]
>>@@ -545,6 +551,7 @@ static int make_request(request_queue_t 
>>        r1_bio->sector = bio->bi_sector;
>> 
>>        r1_bio->state = 0;
>>+       r1_bio->tried_disks = 0;
> 
> Hmm. Ditto. I suppose we are making the read request here. Yes we are.
> I had set the "remaining" count instead.

BTW there's no reason to zero any fields in r1_bio because of the
way it is allocated (with memset(0) all of it).

[]
> What do you think of my comments above?

Ok.

But..  It's very difficult to NOT go into numerous-cleanups mode now.
I want to clean up the code, to make it better first!.. ;)  And I
pretty much sure it will conflict with ongoing work Neil is doing... ;)

/mjt
