From: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Subject: AW: AW: RAID1 and data safety?
Date: Tue, 29 Mar 2005 10:54:55 +0200
Message-ID: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wrote:
>> 
>> Still, if there is different data on the two disks due to a previous 
>> power failure, the comparsion could really be the better choise, isn't it?
>> 
>

Neil wrote:
>What does a comparison of two blocks tell you?  That they are
>different, not which one is "right".
>
>A filesystem designed to handle these sort of problems wouldn't suffer
>from data inconsistencies due to power off.  It would "know" where it
>was up to and would either re-write or ignore any data that it doesn't
>know to certainly be safe.

But:
If you have a raid1 and a journaling fs, see the following:
If the system chrashes at the end of a write transaction,
then the end-of-transaction information may got written 
to hda already, but not to hdb. On the next boot, the 
journaling fs may see an overall unclean bit (*probably* a transaction
is pending), so it reads the transaction log. 

And here the fault happens:
By chance, it reads the transaction log from hda, then sees, that the
transaction was finished, and clears the overall unclean bit. 
This cleaning is a write, so it goes to *both* HDs.

Situation now: On hdb there is a pending transaction in the transaction 
log, but the overall unclean bit is cleared. This may not be realised,
until by chance a year later hda chrashes, and you finaly face the fact,
that there is a corrupt situation on the left HD.

Solution approach: if it would have read the transaction log from both HDs,
it would have returned a read fault. A good journaling fs probably stores
the end-of-transaction info in a different block, than the start-of-transaction 
info. Then it can say: If I cannot properly read the end-of-transaction info,
then I consider the transaction as not finished, so I do a rollback. 
(Of course this requires a readable start-of-transaction info, therefore it 
should be stored seperate from the end-of-transaction info.)

Does this sound reasonable?

Thomas
