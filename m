From: Changsen Xu <xucs007@yahoo.com>
Subject: Re: mdadm: which device set as source to mirror?
Date: Sun, 11 Sep 2005 18:22:07 -0500
Message-ID: <1126480927.6058.4.camel@r40>
References: <1126458858.6042.6.camel@r40>
	 <17188.44497.481437.390441@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17188.44497.481437.390441@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html_single/Software-RAID-HOWTO.html#ss7.6

Look, RAIDTOOLS clearly stated source is "raid-disk 0", but your
current mdadm has no specifications on this matter. Maybe 
one more command line switch, such as "--source /dev/hdb3",
can be added to your next release?

Regards,  



On Mon, 2005-09-12 at 08:21 +1000, Neil Brown wrote:
> On Sunday September 11, xucs007@yahoo.com wrote:
> > Dear Neil Brown,
> > 
> > I'm trying to learn how to use your great mdadm,
> > one thing I'm not quite sure, and couldn't find
> > any clue in your man page, is,
> > 
> > During create or assemble mode, for RAID1, which
> > device mdadm uses as source to make the mirroring?
> > Is there any differences to determine it
> > for situations of same-size devices and different-size
> > devices (>1% differences) ?
> 
> I think it copies from the smallest numbered working drive (i.e. drive
> 0 if that is working, else drive 1, etc).  However it really
> shouldn't matter to you.  If you are doing something that depends on
> having the right answer to this, you are probably doing it the wrong
> way.  
> 
> If you would like to discuss it further, I suggest explaining what you
> want to do, and why you think you need to know this, to
> linux-raid@vger.kernel.org. 
> 
> NeilBrown
> 
-- 
  Changsen Xu
 

