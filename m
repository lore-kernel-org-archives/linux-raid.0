From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6: help wanted
Date: Mon, 25 Oct 2004 16:24:54 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16764.39990.547866.885761@cse.unsw.edu.au>
References: <cleqh6$ps4$1@terminus.zytor.com>
	<16764.37392.910080.718564@cse.unsw.edu.au>
	<20041025062026.GA17502@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Paris on Monday October 25
To: Jim Paris <jim@jtan.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 25, jim@jtan.com wrote:
> > Does this fix the problem?
> > It is definitely wrong as it is.
> > 
> ..
> >  	case RECONSTRUCT_WRITE:
> > -	case UPDATE_PARITY:	/* Is this right? */
> 
> No, it does not.  Same sort of corruption with that line removed.
> 
 
Thanks.  I'll try harder...

Looking at the script, the corruption happens while resync is still
going on.  If you wait for resync to finish, do you still get
corruption?

NeilBrown
