From: Neil Brown <neilb@suse.de>
Subject: Re: Lilo append= ,  A suggestion .
Date: Tue, 14 Feb 2006 18:15:24 +1100
Message-ID: <17393.33676.306102.491448@cse.unsw.edu.au>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH>
	<054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH>
	<055901c5f30c$282ad520$200a11ac@NCNF5131FTH>
	<058201c5f386$bf23d150$200a11ac@NCNF5131FTH>
	<17290.11404.619425.81197@cse.unsw.edu.au>
	<Pine.LNX.4.64.0602132106560.2467@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Monday February 13
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday February 13, babydr@baby-dragons.com wrote:
>  	Hello Neil & All ,
>  	I'll bet I am going to get harassed over this , but ...
> 
>  	The present form (iirc) of the lilo append statement is
> 
>  	append="md=d0,/dev/sda,/dev/sdb"
> 
>  	I am wondering how difficult the below would be to code ?
>  	This allows a (relatively) short strings to be append'd
>  	instead of the sometimes large listing of devices .
> 
>  	append="md=d0,UUID=e9e0f605:9ed694c2:3e2002c9:0415c080"
> 
>  	Ok ,  I got my asbestos brithes on .  Have at it ;-) .

This is just the job for an initramfs.  They are *really*easy* to
make, and very flexible.  mdadm-2.2 and later come with a little
script which (tested on Debian) makes a simple initramfs which
will recognise a kernel parameter (as passed by lilo's 'append')
like
        rootuuid=97e58306:2c85fd85:2346b91e:aaca5fee

and will assemble the appropriate array a /dev/md_d0 and will then
mount a filesystem of there as root.  If it doesn't do exactly what
you want, it is fairly easy to modify.

NeilBrown
