From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: what does spares=1 mean  in mdadm --detail --scan for raid1
Date: Fri, 29 Apr 2005 04:44:17 -0400
Message-ID: <200504290444.17675.mlaks@verizon.net>
References: <200504290638.j3T6cEm19128@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-8-i
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200504290638.j3T6cEm19128@www.watkins-home.com>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 29 April 2005 02:38 am, Guy wrote:

> >
> > what is the meaning of spares=1?
>
> When you add a disk it is a spare.
i see. 

So it is important information but not intended for mdadm.conf....

indeed when the rsync completed it no longer said
spares=1 in 
mdadm --detail --scan

so i left it out of the mdadm.conf for the next time and it worked.

thanks,
Mitchell
