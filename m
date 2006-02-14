From: Luca Berra <bluca@comedia.it>
Subject: Re: Lilo append= ,  A suggestion .
Date: Tue, 14 Feb 2006 08:17:10 +0100
Message-ID: <20060214071710.GA20538@percy.comedia.it>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH> <054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH> <055901c5f30c$282ad520$200a11ac@NCNF5131FTH> <058201c5f386$bf23d150$200a11ac@NCNF5131FTH> <17290.11404.619425.81197@cse.unsw.edu.au> <Pine.LNX.4.64.0602132106560.2467@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0602132106560.2467@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 13, 2006 at 09:12:42PM -0700, Mr. James W. Laferriere wrote:
>	Hello Neil & All ,
>	I'll bet I am going to get harassed over this , but ...
>
>	The present form (iirc) of the lilo append statement is
>
>	append="md=d0,/dev/sda,/dev/sdb"
>
>	I am wondering how difficult the below would be to code ?
>	This allows a (relatively) short strings to be append'd
>	instead of the sometimes large listing of devices .
>
>	append="md=d0,UUID=e9e0f605:9ed694c2:3e2002c9:0415c080"
>
>	Ok ,  I got my asbestos brithes on .  Have at it ;-) .
>		Tia ,  JimL
what about all the past threads about in-kernel autodetection?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
