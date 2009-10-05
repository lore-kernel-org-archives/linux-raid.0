From: adfas asd <chimera_god@yahoo.com>
Subject: RE: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 06:58:54 -0700 (PDT)
Message-ID: <427502.68563.qm@web38806.mail.mud.yahoo.com>
References: <20091005045942600.WUNS18886@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091005045942600.WUNS18886@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- On Sun, 10/4/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> > I am
> working on putting / on a
> > dedicated high-performance 2.5" drive and keeping my
> videos on the array
> > as they're much too large to back up.
> 
>     You've said that before, but it is
> specious, as you are potentially
> using more space to mirror them on a RAID array than you
> would by
> implementing a backup array.  You don't have a
> separate backup, but they are
> using more space on your proposed system than they would be
> with my proposal
> for you.  I also rather expect in the long run it may
> be more of a
> management hassle for you.  It's your decision, of
> course.

I don't understand why you would say this.  Whether I set up a RAID1 in the garage and one in the house and RAID0 them, or just set up a RAID10, it should not have any impact on the space.  And more arrays means -more- management hassle, not less. 

And I don't understand how you can set up an array without partitions?  Do you then LVM it and partition -that-? Is that actually possible?

 


      
