From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: RAID-6: help wanted
Date: Mon, 25 Oct 2004 14:23:28 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <clj290$8mh$1@terminus.zytor.com>
References: <cleqh6$ps4$1@terminus.zytor.com> <16764.37392.910080.718564@cse.unsw.edu.au> <20041025062026.GA17502@jim.sh> <16764.39990.547866.885761@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <16764.39990.547866.885761@cse.unsw.edu.au>
By author:    Neil Brown <neilb@cse.unsw.edu.au>
In newsgroup: linux.dev.raid
>
> On Monday October 25, jim@jtan.com wrote:
> > > Does this fix the problem?
> > > It is definitely wrong as it is.
> > > 
> > ..
> > >  	case RECONSTRUCT_WRITE:
> > > -	case UPDATE_PARITY:	/* Is this right? */
> > 
> > No, it does not.  Same sort of corruption with that line removed.
> > 
>  
> Thanks.  I'll try harder...
> 
> Looking at the script, the corruption happens while resync is still
> going on.  If you wait for resync to finish, do you still get
> corruption?
> 

The version of the script I posted does wait for the resync to finish
before writing; it still exhibits the same problem.

	-hpa
