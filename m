From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Size limitation?
Date: Fri, 1 Jan 2010 17:00:03 -0600
Message-ID: <D1.4F.08392.B6E7E3B4@cdptpa-omtalb.mail.rr.com>
References: <201001011457.24334.mmclagan@invlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201001011457.24334.mmclagan@invlogic.com>
Sender: linux-raid-owner@vger.kernel.org
To: mmclagan+reply@invlogic.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hello,
> 
>    I'm trying to set up a large array but isn't working.  I tried
> Googling size limits, etc and came up empty.
> 
> The problem is that with 10 drives (300GB SCSI), the array is coming up
> with 500GB of space?!?  I did an experiment and when the array size
> exceeds 2TB, it fails/wraps?
> 
> Is there a solution (simple or otherwise) for this?  The machine runs
> 2.6.29.5 (anything later causes the machine to lock up :( ).  I'm not
> sure if mdadm or the kernel is the problem either.
> 
> Any suggestions appreciated (please CC me on replies).

	Well, I know the 0.90 superblock limits the COMPONENT devices to
2TB, but I know for a fact it doesn't limit the array itself to 2TB, at
least not using mdadm 2.6.7.2, because I have created arrays much larger
than 2T using a 0.90 superblock.  There is also a limit of 28 component
devices using a 0.90 superblock, but you are nowhere near that limit.
Nonetheless, why not try using a 1.x superblock, instead?  It can't hurt to
try.  What version of mdadm are you using?  I'm using a 2.6.26-2 kernel, so
I would think 2.6.29.5 would not have any limitations that 2.6.26 doesn't.

