From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is It Hopeless?
Date: Sun, 26 Dec 2010 22:45:37 -0600
Message-ID: <4D1819F1.3090504@hardwarefreak.com>
References: <201012261019.56481.CACook@quantum-sci.com> <201012261219.41912.CACook@quantum-sci.com> <20101227073330.6acb577a@notabene.brown> <201012261606.29281.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012261606.29281.CACook@quantum-sci.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carl Cook put forth on 12/26/2010 6:06 PM:
> On Sun 26 December 2010 12:33:30 Neil Brown wrote:
>> But the important thing is that you have your data back, preparing you for a
>> Happy New Year!
>> NeilBrown
> 
> Indeed.  Thank you Neil, you saved me (along with my not touching anything).
> 
> 
> On Sun 26 December 2010 13:14:32 you wrote:
>> Excellent save!!!  The OP might want to continue the "Giving Season" by 
>> giving himself a brand new system backup.
> 
> Actually I have much too much data to back anything up

 <snip>

Every time I read/hear this I cringe.  If that is the case your data is
worthless to begin with so just delete it all right now.  You are
literally saying the same thing with your statement.  The difference is
that I _KNOW_ you drives will fail, or you'll lose an array due to
corruption, etc.  Your HTPC storage system will fail.  It's not an _IF_
but a _WHEN_ issue.  The question then becomes, what is the best
backup/restore strategy to fit HTPC needs.  Build another system with
similar technology and you have the same failure modes and risks as the
first.

Spinning Rust Disks (SRDs) are not a suitable long term backup/restore
solution.  What happens when your disk-to-disk backup server solution
drops an MD array for no reason such as just happened, _during_ a
restore operation?  Or you suffer a disk failure on the backup server
during a restore operation (which is very common today)?  Will your
backup server contain a 4 x 2 TB disk RAID 10 set?

I'd suggest tape as the better solution to D2D in the HTPC case,
primarily based on cost and availability of library and media, and the
fact the disaster recover procedure is much easier and much more
straightforward:

8 drive LTO-2 autoloader

http://www.msrcglobal.com/p-216-af203a.aspx?gclid=CI789Mm_i6YCFQTrKgodIg0pnA&
http://h18000.www1.hp.com/products/quickspecs/11841_div/11841_div.HTML
Ultrium 448 drive
3.2 TB compressed max per library
U160 LVD/SE SCSI interface
172 GB/hour capacity -
"desktop" model
$650 USD

http://www.newegg.com/Product/Product.aspx?Item=N82E16816118057
$90 USD

http://www.newegg.com/Product/Product.aspx?Item=N82E16840999118
8 x $22 = $176 USD

Total = $916 + shipping

Using the correct backup strategy this should easily meet your needs.
The 8 tapes in the library will handle 75% of your RAW level 10 mdraid
device capacity.  Once a filesystem is laid down, and you take overhead
concerns into account, you won't be putting more than 3.2 TB of data on
it anyway (or, at least, you SHOULDN'T be doing so).

The total cost should be similar to a disk based backup server but the
reliability and ease of restore should be better.  There's no beating a
tape library as a long term backup solution, especially for data that
doesn't change often, such as HTPC files.  10 tapes for 4 TB of space is
$220.  How much does a 4 TB SATA drive cost?  Or 2 x 2TB drives.  Quite
a bit more.  You can store spare tapes more easily than spare drives,
and the tapes take almost zero configuration when adding capacity to the
backup system.  Adding drives, especially if you don't buy a large
chassis with hot swap bays up front, is much more a PITA.

Keep in mind that using tape allows essentially unlimited backup
expansion, whereas you are severely limited with a backup server for
your HTPC unless you buy a large box upfront, which nobody doing HTPC
wants.  Each time you add larger/more disks to the HTPC, you have to do
the same for the backup server.  With tape, you simply swap tape
inventory and create a modified or new backup schedule.

Many people outside the corporate/government data center completely
ignore tape today as a backup solution.  Many times at their peril.

-- 
Stan
