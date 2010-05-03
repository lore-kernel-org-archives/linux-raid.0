From: Neil Brown <neilb@suse.de>
Subject: Re: Suggestion needed for fixing RAID6
Date: Tue, 4 May 2010 07:02:00 +1000
Message-ID: <20100504070200.55be73c7@notabene.brown>
References: <626601cae203$dae35030$0400a8c0@dcccs>
	<695a01cae2c1$a72907d0$0400a8c0@dcccs>
	<4BD193D0.5080003@shiftmail.org>
	<717901cae3e5$6a5fa730$0400a8c0@dcccs>
	<4BD3751A.5000403@shiftmail.org>
	<756601cae45e$213d6190$0400a8c0@dcccs>
	<4BD569E2.7010409@shiftmail.org>
	<7a3e01cae53f$684122c0$0400a8c0@dcccs>
	<4BD5C51E.9040207@shiftmail.org>
	<80a201cae621$684daa30$0400a8c0@dcccs>
	<4BD76CF6.5020804@shiftmail.org>
	<20100428113732.03486490@notabene.brown>
	<4BD830B0.1080406@shiftmail.org>
	<025e01cae6d7$30bb7870$0400a8c0@dcccs>
	<4BD843D4.7030700@shiftmail.org>
	<062001cae771$545e0910$0400a8c0@dcccs>
	<4BD9A41E.9050009@shiftmail.org>
	<0c1201cae7e0$01f9a930$0400a8c0@dcccs>
	<4BDA0F88.70907@shiftmail.org>
	<0d6401cae82c$da8b5590$0400a8c0@dcccs>
	<4BDB6DB6.5020306@shiftmail.org>
	<12cf01cae911$f0d92940$0400a8c0@dcccs>
	<4BDC6217.9000209@shiftmail.org>
	<154b01cae977$6e09da80$0400a8c0@dcccs>
	<20100503121747.7f2cc1f1@notabene.brown>
	<4BDE9FB6.80309@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDE9FB6.80309@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: Janos Haar <janos.haar@netcenter.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 03 May 2010 12:04:38 +0200
MRK <mrk@shiftmail.org> wrote:

> On 05/03/2010 04:17 AM, Neil Brown wrote:
> > On Sat, 1 May 2010 23:44:04 +0200
> > "Janos Haar"<janos.haar@netcenter.hu>  wrote:
> >
> >    
> >> The general problem is, i have one single-degraded RAID6 + 2 badblock disk
> >> inside wich have bads in different location.
> >> The big question is how to keep the integrity or how to do the rebuild by 2
> >> step instead of one continous?
> >>      
> > Once you have the fix that has already been discussed in this thread, the
> > only other problem I can see with this situation is if attempts to write good
> > data over the read-errors results in a write-error which causes the device to
> > be evicted from the array.
> >
> > And I think you have reported getting write
> > errors.
> >    
> 
> His dmesg AFAIR has never reported any error of the kind "raid5:%s: read 
> error NOT corrected!! " (the error message you get on failed rewrite AFAIU)
> Up to now (after my patch) he only tried with MD above DM-COW and DM was 
> dropping the drive on read error so I think MD didn't get any 
> opportunity to rewrite.

Hmmm... fair enough.

> 
> It is not clear to me what kind of error MD got from DM:
> 
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: device-mapper: snapshots: Invalidating snapshot: Error reading/writing.
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: ata8: EH complete
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5: Disk failure on dm-1, disabling device.
> 
> I don't understand from what place the md_error() is called...

I suspect it is from raid5_end_write_request.  It looks like we don't print
any message when the re-write fails.  Only if the read after the rewrite
fails.

> but also in this case it doesn't look like a rewrite error...
> 

... so I suspect it is a rewrite error.  Unless I missed something.  What
message did you expect to see in the case of a re-write error?

> I think without DM COW it should probably work in his case.
> 
> Your new patch skips the rewriting and keeps the unreadable sectors, 
> right? So that the drive isn't dropped on rewrite...

Correct.


> 
> > The following patch should address this issue for you.
> > It is*not*  a general-purpose fix, but a specific fix
> [CUT]

NeilBrown
