From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ADD_NEW_DISK failed
Date: Mon, 24 Feb 2003 09:32:00 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15961.19424.978223.31131@notabene.cse.unsw.edu.au>
References: <5.1.0.14.0.20030223085025.00b08b30@psimail.spindrift.on.ca>
	<3E58EBA1.7010305@ratnet.stw.uni-erlangen.de>
	<15961.12440.64252.132242@notabene.cse.unsw.edu.au>
	<20030223205156.GB774@smeagol>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Adam Luter on Sunday February 23
To: Adam Luter <luterac@bellsouth.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 23, luterac@bellsouth.net wrote:
> Just add "" around missing:
> 
> ... give the word "missing" in place ...

Well, it's bold in the original - cut-and-paste from an xterm lost
that.
Maybe quotes would make it clearer...

thanks,
NeilBrown

> 
> -Adam Luter
> 
> On Mon, Feb 24, 2003 at 07:35:36AM +1100, Neil Brown wrote:
> > Fourth paragraph of the "CREATE MODE" section:
> > 
> >        To create a "degraded" array in which some devices are missing,  simply
> >        give the word missing in place of a device name.  This will cause mdadm
> >        to leave the corresponding slot in the array empty.   For  a  RAID4  or
> >        RAID5  array  at most one slot can be missing.  For a RAID1 array, only
> >        one real device needs to be given.  All of the others can be missing.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
