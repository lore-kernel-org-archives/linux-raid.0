From: Jim Paris <jim@jtan.com>
Subject: Re: RAID-6: help wanted
Date: Mon, 25 Oct 2004 02:33:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025063341.GA17825@jim.sh>
References: <cleqh6$ps4$1@terminus.zytor.com> <16764.37392.910080.718564@cse.unsw.edu.au> <20041025062026.GA17502@jim.sh> <16764.39990.547866.885761@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16764.39990.547866.885761@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > -	case UPDATE_PARITY:	/* Is this right? */
> > 
> > No, it does not.  Same sort of corruption with that line removed.
>  
> Thanks.  I'll try harder...
> 
> Looking at the script, the corruption happens while resync is still
> going on.  If you wait for resync to finish, do you still get
> corruption?

The problem shows up when the array is degraded (either 1 or 2 disks
missing), regardless of resync.  If the array is not degraded,
everything works fine, again regardless of resync.

-jim


