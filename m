From: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Subject: Re: fsck on raidvolumes at boot
Date: Sun, 11 May 2003 16:48:15 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.OSF.4.51.0305111646340.136560@soul.helsinki.fi>
References: <871y0ejtdf.fsf@jumper.lonesom.pp.fi>
 <Pine.OSF.4.51.0305102009550.135362@soul.helsinki.fi>
 <16061.61482.79132.824395@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16061.61482.79132.824395@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello Neil and All!

On Sun, 11 May 2003, Neil Brown wrote:

> > Is there a way to make Linux automatically check the /dev/md*'s before
> > mounting them if they are dirty?
>
> What number do you have in column 6 of /etc/fstab for these
> filesystems?
> If 0, make it non-zero.

Thank you very much! When knowing what to search for, it was easy :-) I
guess the recommended value is 2 for non-root partitions. I had both col 5
and 6 plain empty...

Have a nice day,
    Mikael J.
    http://www.helsinki.fi/~mpjohans/
