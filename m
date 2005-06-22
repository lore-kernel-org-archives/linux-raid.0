From: Brad Dameron <brad@seatab.com>
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 14:09:25 -0700
Message-ID: <1119474566.11039.12.camel@dhcpc226.office.pivotlink.com>
References: <5d96567b05061804477325d743@mail.gmail.com>
	 <200506201853.11768.hjm@tacgi.com> <42B9BCF6.1010206@h3c.com>
	 <200506221316.33178.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506221316.33178.hjm@tacgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2005-06-22 at 13:16 -0700, Harry Mangalam wrote:
> Thanks for the note - I'd also be interested in what drives people people use 
> that seem to be robust and which are having problems.  The 3ware tech that I 
> spoke to recommended the WD-SD series, but a local senior sysadmin has warned 
> his entire dept off WD drives for the reasons I've mentioned.  He rec'ed 
> Seagate (5 year warr) and Hitachi.  So far the only good thing that I can say 
> about WD is that their return policy has been relatively smooth (tho they 
> smoothly keep returning bad drives :( )
> 
> I personally buy IBM (now Hitachi I think) and Seagate and have always avoided 
> WD as being cheap and cheesy.  5 years ago when I was a sysadmin, I was 
> replacing WD at probably 5 times the rate of anything else.  It was probably 
> strongly influenced by the fact that more people were using them than the 
> others but I don't think I've ever had an IBM or seagate 3.5" die (have a 
> teetering stack of working ones that just got too small to bother with).  I 
> figured that since WD was still in business (tho seeming always on the verge 
> of going bust) their quality must have improved, but maybe not.
> 
> Happy to be contradicted.  If there's a 'Consumer's Reports' for HD 
> reliability on the web, I couldn't find it.  Maybe it's time to set one up - 
> with SMART disk records, it's possible to get more reliable runtime records 
> and data than just the usual single point or small data set that individuals 
> can provide (and you can bet that most vendors aren't going to make their 
> failures public..).
> 
> Perhaps something like the CDDB, where a you can run an applet on a cronjob 
> that will upload your disk's SMART data cache to a remote DB on a regular 
> basis, so the millions of disks out there can be profiled.  Hmmm - sounds 
> like a good undergrad project. Did someone say Summer of Code? 
> (http://code.google.com/summerofcode.html)
> 
> hjm

Everyone has had issues with one brand or another. Sometimes the
shipping can make all the difference. As I have had 4-5 out of 16 drives
shipped come up bad out of the box. And these were Seagate 73GB SCSI
drives. Not some cheap SATA/PATA drives. Now when you come to comparing
drives you have to remember that not all manufacturers make their own
drives. It is know that WD has sold IBM drives as theirs and vice-versa.
I currently have a 12 drive 3ware 9500S-12 with 73GB WD 10k raptor
drives in it that has been online for a year and a month without issues.
And the controller has the very first firmware and linux drivers out. 
I also have several hundred Seagate SCSI 10k drives from 36gb to 146gb. 
And a few dozen Fujitsu 15k 73gb SCSI drives. And out of all these
drives Seagate is the only ones I have to keep sending in for RMA. Now
mind you I do have about 5 times as many drives. 

I used to not be partial to Maxtor either due to a issue several years
ago with their PATA drives dieing on me in bulk. But I am currently
purchasing 16 of their Maxline III SATA 300GB drives for a large storage
array. Why am I going with them? Because they have the best reported
performance for this type of drive. Not because they have a record of
lasting longer. It is too hard to tell in a production/semi-production
environment which brand will last the longest. So go with what you think
is the best. And have spares/backups and monitoring programs to be
prepared for when one does die. The odds of multiple failures at the
same time are pretty high. 

And just for the record, look at the Areca SATA RAID cards. They have 16
and even 24 port cards if you want very large arrays. The cards greatly
out perform the 3ware cards in READ/WRITE performance. They even offer
RAID6. Just look at the processor on the ARC-12xx series.

Just my 2 cents. Hope it helps.

Brad Dameron
SeaTab Software
www.seatab.com


