From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: AW: AW: RAID1 and data safety?
Date: Tue, 29 Mar 2005 20:08:51 +1000
Message-ID: <16969.10547.894461.398225@cse.unsw.edu.au>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Schuett Thomas EXT on Tuesday March 29
Sender: linux-raid-owner@vger.kernel.org
To: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 29, Thomas.Schuett.extern@mchh.siemens.de wrote:
> But:
> If you have a raid1 and a journaling fs, see the following:
> If the system chrashes at the end of a write transaction,
> then the end-of-transaction information may got written 
> to hda already, but not to hdb. On the next boot, the 
> journaling fs may see an overall unclean bit (*probably* a transaction
> is pending), so it reads the transaction log. 
> 
> And here the fault happens:
> By chance, it reads the transaction log from hda, then sees, that the
> transaction was finished, and clears the overall unclean bit. 
> This cleaning is a write, so it goes to *both* HDs.
> 
> Situation now: On hdb there is a pending transaction in the transaction 
> log, but the overall unclean bit is cleared. This may not be realised,
> until by chance a year later hda chrashes, and you finaly face the fact,
> that there is a corrupt situation on the left HD.

Wrong.  There is nothing of the sort on hdb.  
Due to the system crash the data on hdb is completely ignored.  Data
from hda is copied over onto it.  Until that copy has completed,
nothing is read from hdb.

You could possibly come up with a scenario where the above happens but
while the copy from hda->hdb is happening, hda dies completely so
reads have to start happening from hdb.  
md could possibly handle this situation better (ensure a copy has
happened for any block before a read succeeds of that block), but I
don't think it is at all likely to be a re-life problem.

NeilBrown
