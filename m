From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Some raid1 questions
Date: Mon, 2 Feb 2004 15:43:46 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16413.54658.442268.733528@notabene.cse.unsw.edu.au>
References: <200402011438.01880.yg@mind.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yves Glodt on Sunday February 1
To: Yves Glodt <yg@mind.lu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 1, yg@mind.lu wrote:
> Hello,
> 
> I have my home partition on a raid1 device, and there is an ext3 
> filesystem on it. Some more information:
...
> 
> Recently I had some freezes (due to nvidia...?), and everytime I had to 
> make a hard reset.
> 
> Everytime then the raid resynced completely which took about 1.5 hours.
> One time I lost some kde settings when this happened.
> The filesystem did not complain about an unclean shutdown, it seems it 
> did not see on bootup that the last shutdown was unclean.
> 
> Now to my questions:
> Is this the normal behaviour?
Which behaviour?

  1.5 hour resync -- maybe. It depends on the speed and size of the
    drives.
  lost kde settings -- maybe. It depends on how well kde copes with
    sudden system failure.
  The filesystem didn't complain -- Yes.  ext3 doesn't complain about
    an unclean shutdown.  It just replays the journal and keeps
    working. 

> Shouldn't the filesystem take care of that?

  Take care of what?  I suspect it did take care of everything it
  could. 

> What is the point of having a journaling filesystem on a mirror?
  Lots.  A journaling filesystem guards against unclean shutdown.  A
  mirror guards against drive failure.  These are compliementary.

> Is there anything I can change to have the filesystem handle unclean 
> shutdowns?

 I think it did handle the unclean shutdown just fine.
 The loss of kde settings is probably dud to KDE note being careful
 enough when updating it's settings file.

NeilBrown

> 
> TIA,
> Yves
> 
> 
> -- 
> Linux 2.4.24 #5 Mon Jan 5 19:38:06 CET 2004 i686
>  14:25:55 up  4:14,  1 user,  load average: 0.43, 0.40, 0.32
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
