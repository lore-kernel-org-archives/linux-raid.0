From: Luca Berra <bluca@comedia.it>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks
	reporting "No md superblock detected"?
Date: Tue, 10 Feb 2009 09:55:03 +0100
Message-ID: <20090210085503.GA11220@maude.comedia.it>
References: <1233775657.10151.5.camel@localhost.localdomain> <18827.51024.270348.20624@notabene.brown> <alpine.LNX.2.00.0902061903510.21732@filesrv1.baby-dragons.com> <9B27D278-ED85-498A-8EF6-DDB7EFB103F7@unh.edu> <499017CB.30307@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <499017CB.30307@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

im going a bit ot, bare with me.
On Mon, Feb 09, 2009 at 01:47:23PM +0200, Max Waterman wrote:
> I only have the one drive (sda) on this computer, so 'sa[abcd]1' only 
> matched one drive. The unexpected bit is that the shell passed on the arg 
> 'as is' when it didn't match any file (IIRC that's different for csh, which 
> I notice you're using).
filename generation (glob) syntax is common to all shell iirc
behaviour when globbing does not match varies

ksh: will pass the argument unmodified, which i believe is posix.

csh: depends on option nonomatch, if set lets the argument unmodified,
else (default) will print an error.
         csh% got light?
         No Match.

bash: has two options that controll globbing
         default is as ksh
         failglob: if set prints error, like csh
         nullglob: if set just ignores the pattern (i.e. replaces it with
nothing)

zsh: rtfm


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
