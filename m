From: Jim Paris <jim@jtan.com>
Subject: Re: RAID-6: help wanted
Date: Mon, 25 Oct 2004 02:20:26 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025062026.GA17502@jim.sh>
References: <cleqh6$ps4$1@terminus.zytor.com> <16764.37392.910080.718564@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16764.37392.910080.718564@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Does this fix the problem?
> It is definitely wrong as it is.
> 
..
>  	case RECONSTRUCT_WRITE:
> -	case UPDATE_PARITY:	/* Is this right? */

No, it does not.  Same sort of corruption with that line removed.

-jim
