From: Nifty Fedora Mitch <niftyfedora@niftyegg.com>
Subject: Re: Awful RAID5 random read performance
Date: Thu, 4 Jun 2009 15:40:54 -0700
Message-ID: <20090604224054.GA17121@compegg.wr.niftyegg.com>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com> <200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com> <20090602194704.GA30639@rap.rap.dk> <4A25B201.2000705@anonymous.org.uk> <4A26C313.6080700@tmr.com> <4A26D5AE.2000003@anonymous.org.uk> <878wk9q7qp.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878wk9q7qp.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 04, 2009 at 12:21:02AM +0200, Goswin von Brederlow wrote:
.....mi
> 
> Anyone know what the size of a track is on modern disks? How many
> sectors/track do they have?

The number will differ from the inside to the outside of the
disk.  The number of zones will differ from drive to drive too....

Some diagnostic software will either know this or 
have vendor specific ways to get it live from the disk.

Data sheets now report average... At one time vendors 
made a big deal on this...
http://www.impediment.com/seagate/s2000/spec_318436lcv.shtml
    Sectors/Track (avg)  	426
    Bytes/Track (avg) 	218,112

If you take numbers like:
    Track Density (TPI) 	18,145 tracks/inch
    Recording Density (BPI, max) 	328,272 bits/inch 
and dust off some geometry you might discover
how many more bits are possible on the outside
tracks vs the inside tracks and then take those
bits and estimate the number of additional blocks.
An estimate may all you get because spares and 
other uses for bits will be hidden.




-- 
	T o m  M i t c h e l l 
	Found me a new hat, now what?

