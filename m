From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: RAID5 Not coming back up after crash
Date: Tue, 30 Nov 2004 22:29:25 +0100
Message-ID: <20041130212925.GA14220@janus>
References: <41AB4F52.3030001@wisc.edu> <200411291741.iATHf0N05834@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200411291741.iATHf0N05834@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: "'B. J. Zolp'" <bjzolp@wisc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 29, 2004 at 12:40:54PM -0500, Guy wrote:
> 
> Also, it is common for a disk to grow bad spots over time.  These bad spots
> (sectors) can be re-mapped by the drive to a spare sector.  This re-mapping
> will occur when an attempt is made to write to the bad sector.  So, you can
> repair your disk by writing to the bad sectors.  But, be careful not to
> overwrite good data.  I have done this using dd.

If you know the pathname of the file containing the bad spot (and have a copy
of the file then you could use shred(1):

NAME
       shred  -  delete a file securely, first overwriting it to hide its con-
       tents

SYNOPSIS
       shred [OPTIONS] FILE [...]
...


-- 
Frank
