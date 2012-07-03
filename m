From: Christian Balzer <chibi@gol.com>
Subject: Re: Fatal crash/hang in scsi_lib after RAID disk failure
Date: Tue, 3 Jul 2012 15:10:38 +0900
Message-ID: <20120703151038.428af28f@batzmaru.gol.ad.jp>
References: <20120629093552.1651d3c2@batzmaru.gol.ad.jp>
	<20120703155045.570a2bee@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703155045.570a2bee@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Jul 2012 15:50:45 +1000 NeilBrown wrote:

> On Fri, 29 Jun 2012 09:35:52 +0900 Christian Balzer <chibi@gol.com>
> wrote:
> 
> > 
> > Hello (Neil),
> > 
> > This may or may not be related to the same main error I found a
> > reference to on the ML archives from November 2011 
> > (kernel BUG at drivers/scsi/scsi_lib.c:1153).
> > 
> > Again, this is a 3.2.20 kernel, now with the Raid10 recovery bug patch,
> > but I don't see how this could be related.
> > 
> > The full initial dump, as far as it was logged is here:
> > http://pastebin.com/wFX5yew2
> > 
> > But the juicy bits are these:
> > ---
> > Jun 29 05:06:42 borg03b kernel: [231632.877579] sd 8:0:5:0: [sdj]
> > Unhandled sense code Jun 29 05:06:42 borg03b kernel: [231632.877583]
> > sd 8:0:5:0: [sdj]  Result: hostbyte=invalid driverbyte=DRIVER_SENSE
> > Jun 29 05:06:42 borg03b kernel: [231632.877586] sd 8:0:5:0: [sdj]
> > Sense Key : Medium Error [current] Jun 29 05:06:42 borg03b kernel:
> > [231632.877590] Info fld=0x904ff8b8 Jun 29 05:06:42 borg03b kernel:
> > [231632.877591] sd 8:0:5:0: [sdj]  Add. Sense: Unrecovered read error
> > Jun 29 05:06:42 borg03b kernel: [231632.877595] sd 8:0:5:0: [sdj] CDB:
> > Read(10): 28 00 90 4f f8 3f 00 00 f8 00 Jun 29 05:06:42 borg03b
> > kernel: [231632.877602] end_request: critical target error, dev sdj,
> > sector 2421159999 Jun 29 05:06:42 borg03b kernel: [231632.881963]
> > md/raid10:md4: sdj1: rescheduling sector 6052895744 Jun 29 05:06:46
> > borg03b kernel: [231636.380147] sd 8:0:5:0: [sdj] Unhandled sense code
> > Jun 29 05:06:46 borg03b kernel: [231636.380150] sd 8:0:5:0: [sdj]
> > Result: hostbyte=invalid driverbyte=DRIVER_SENSE Jun 29 05:06:46
> > borg03b kernel: [231636.380153] sd 8:0:5:0: [sdj]  Sense Key : Medium
> > Error [current] Jun 29 05:06:46 borg03b kernel: [231636.380157] Info
> > fld=0x904ff8b8 Jun 29 05:06:46 borg03b kernel: [231636.380159] sd
> > 8:0:5:0: [sdj]  Add. Sense: Unrecovered read error Jun 29 05:06:46
> > borg03b kernel: [231636.380162] sd 8:0:5:0: [sdj] CDB: Read(10): 28 00
> > 90 4f f8 b7 00 00 08 00 Jun 29 05:06:46 borg03b kernel:
> > [231636.380168] end_request: critical target error, dev sdj, sector
> > 2421160119 Jun 29 05:06:46 borg03b kernel: [231636.401781]
> > ------------[ cut here ]------------ Jun 29 05:06:46 borg03b kernel:
> > [231636.405694] kernel BUG at drivers/scsi/scsi_lib.c:1153! Jun 29
> > 05:06:46 borg03b kernel: [231636.405694] invalid opcode: 0000 [#1] SMP
> > ---
> > 
> > So a drive died, which shouldn't be a big deal and the kernel decided
> > to jump off the proverbial bridge.
> > 
> > And kept doing that upon reboots:
> > ---
> > Jun 29 06:44:38 borg03b kernel: [   52.052257] end_request: critical
> > target error, dev sdj, sector 2421149759 Jun 29 06:44:38 borg03b
> > kernel: [   52.054654] md/raid10:md4: sdj1: rescheduling sector
> > 6052870144 Jun 29 06:44:38 borg03b kernel: [   52.057104]
> > md/raid10:md4: sdj1: rescheduling sector 6052870392 Jun 29 06:44:38
> > borg03b kernel: [   52.059521] md/raid10:md4: sdj1: rescheduling
> > sector 6052870400 Jun 29 06:44:38 borg03b kernel: [   52.061878]
> > md/raid10:md4: sdj1: rescheduling sector 6052870648 Jun 29 06:44:38
> > borg03b kernel: [   52.064255] md/raid10:md4: sdj1: rescheduling
> > sector 6052870656 Jun 29 06:44:38 borg03b kernel: [   52.066562]
> > md/raid10:md4: sdj1: rescheduling sector 6052870904 Jun 29 06:44:38
> > borg03b kernel: [   52.068872] md/raid10:md4: sdj1: rescheduling
> > sector 6052870912 Jun 29 06:44:38 borg03b kernel: [   52.071141]
> > md/raid10:md4: sdj1: rescheduling sector 6052871160 Jun 29 06:44:39
> > borg03b kernel: [   52.250525] md/raid10:md4: sdj1: redirectingsector
> > 6052865024 to another mirror Jun 29 06:44:39 borg03b kernel:
> > [   52.276817] md/raid10:md4: sdj1: redirectingsector 6052865272 to
> > another mirror Jun 29 06:44:42 borg03b kernel: [   55.325297] sd
> > 8:0:5:0: [sdj] Unhandled sense code Jun 29 06:44:42 borg03b kernel:
> > [   55.325301] sd 8:0:5:0: [sdj]  Result: hostbyte=invalid
> > driverbyte=DRIVER_SENSE Jun 29 06:44:42 borg03b kernel: [   55.325304]
> > sd 8:0:5:0: [sdj]  Sense Key : Medium Error [current] Jun 29 06:44:42
> > borg03b kernel: [   55.325308] Info fld=0x904fc9b4 Jun 29 06:44:42
> > borg03b kernel: [   55.325310] sd 8:0:5:0: [sdj]  Add. Sense:
> > Unrecovered read error Jun 29 06:44:42 borg03b kernel: [   55.325313]
> > sd 8:0:5:0: [sdj] CDB: Read(10): 28 00 90 4f c9 af 00 00 08 00 Jun 29
> > 06:44:42 borg03b kernel: [   55.325320] end_request: critical target
> > error, dev sdj, sector 2421148079 Jun 29 06:44:42 borg03b kernel:
> > [   55.343766] ------------[ cut here ]------------ Jun 29 06:44:42
> > borg03b kernel: [   55.346054] kernel BUG at
> > drivers/scsi/scsi_lib.c:1153! --- Which resulted a bit later in: ---
> > Jun 29 06:45:05 borg03b kernel: [   57.051653] ------------[ cut
> > here ]------------ Jun 29 06:45:05 borg03b kernel: [   57.051653]
> > WARNING: at kernel/watchdog.c:241
> > watchdog_overflow_callback+0x96/0xa1() Jun 29 06:45:05 borg03b kernel:
> > [   57.051653] Hardware name: H8DM3-2 Jun 29 06:45:05 borg03b kernel:
> > [   57.051653] Watchdog detected hard LOCKUP on cpu 7 ---
> > 
> > Not sure if there is a real HW problem (aside from the failing drive)
> > and kettle calling the pot black, but I managed to recover things by
> > booting into single-user mode and removing that failing drive before
> > letting the kernel proceed with booting.
> > 
> > This is pretty bad [TM], any ideas?
> > If you need more information, just let me know.
> 
> That took *way* to long to find given how simple the fix is.

Well, given how long it takes with some OSS projects, I'd say 4 days is
pretty good. ^o^

> I spent ages staring at the code, as about to reply and so "no idea"
> when I thought I should test it myself.  Test failed immediately.

Could you elaborate a bit? 
As in, was this something introduced only very recently, since I had
dozens of disks fail before w/o any such pyrotechnics. 
Or were there some special circumstances that triggered it? 
(But looking at the patch, I guess it should have been pretty universal)

> Then I spent way too look adding tracing into the wrong places.  But I
> have it now!
> 
> Thanks for the report.  Following fix will go upstream shortly.
> (r10_sync_page_io takes sectors, not bytes).
> 
Great to know, I shall keep my eyes on the kernel ChangeLogs and update
as soon as I can. Might just go and patch what I have right now, though...

Thanks for your efforts!

Christian

> Thanks,
> NeilBrown
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index bcf6ea8..ae73e29 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2310,7 +2310,7 @@ static void fix_read_error(struct r10conf *conf,
> struct mddev *mddev, struct r10 if (r10_sync_page_io(rdev,
>  					     r10_bio->devs[sl].addr +
>  					     sect,
> -					     s<<9, conf->tmppage, WRITE)
> +					     s, conf->tmppage, WRITE)
>  			    == 0) {
>  				/* Well, this device is dead */
>  				printk(KERN_NOTICE
> @@ -2349,7 +2349,7 @@ static void fix_read_error(struct r10conf *conf,
> struct mddev *mddev, struct r10 switch (r10_sync_page_io(rdev,
>  					     r10_bio->devs[sl].addr +
>  					     sect,
> -					     s<<9, conf->tmppage,
> +					     s, conf->tmppage,
>  						 READ)) {
>  			case 0:
>  				/* Well, this device is dead */
> @@ -2512,7 +2512,7 @@ read_more:
>  	slot = r10_bio->read_slot;
>  	printk_ratelimited(
>  		KERN_ERR
> -		"md/raid10:%s: %s: redirecting"
> +		"md/raid10:%s: %s: redirecting "
>  		"sector %llu to another mirror\n",
>  		mdname(mddev),
>  		bdevname(rdev->bdev, b),


-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
