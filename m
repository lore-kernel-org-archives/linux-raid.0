From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.8.0 - A tool for managing Soft RAID under Linux
Date: Wed, 3 Nov 2004 14:38:58 +1100
Message-ID: <16776.21202.957419.927413@cse.unsw.edu.au>
References: <46.5c932a76.2eb98e0c@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from AndyLiebman@aol.com on Tuesday November 2
Sender: linux-raid-owner@vger.kernel.org
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 2, AndyLiebman@aol.com wrote:
> >neilb@cse.unsw.edu.au writes:
> >Release 1.8.0 adds:
> >   -   --pid-file option to declare a file to record the pid in for 
> >   --monitor --daemonise
> >    -   Support for new "faulty" personalitiy (see md.4) - not submited to
> >        kernel.org yet.
> >    -   support for raid0 and linear over devices larger than 2 Terabytes.
> >    -   assorted bug fixes.
> 
> Hello Neil, 
> 
> Is this to say that earlier versions of mdadm did NOT support RAID-0 on 
> devices larger than 2 TB? 
> 
> I have been using mdadm 1.6 to create a 4.8 TB RAID-0 array (md0) on top of 
> two 3ware 2.4 TB Hardware RAID-5 arrays (/dev/sda and /dev/sdb) -- and so far I 
> don't see any problems. The RAID-0 is created without trouble. The resulting 
> size is reported as 4.8 TB. The performance is awesome. And, presumably, the 
> data protection is sound.
> 
> Am I missing something? 

Hmmm... I might work with 1.6 if you --build that raid0 (rather than
--create),  or if you are using a 64bit processor like alpha or ia64. 
But mdadm 1.6 definitely have problems in i386 processors when you try
to --create a raid0 with devices larger than 2 terabytes.

NeilBrown
