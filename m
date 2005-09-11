From: Changsen Xu <xucs007@yahoo.com>
Subject: Re: mdadm: which device set as source to mirror?
Date: Sun, 11 Sep 2005 18:07:09 -0500
Message-ID: <1126480029.5932.6.camel@r40>
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

Thanks for your quick response.

It won't matter if I want to use 2 blank partitions to build RAID1;

But now I wish to use mdadm to backup my /home partition, which
already has tons of files on it;

If mdadm happens to choose the other blank partition as source
to do mirroring, all my data on /home will be lost;

Hardware RAID always allows me to choose which partition/drive
to be used as source.

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
 

