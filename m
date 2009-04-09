From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Wed, 8 Apr 2009 22:34:28 -0500
Message-ID: <20090409033432.FZMT19179.cdptpa-omta01.mail.rr.com@Leslie>
References: <49DC6431.2020404@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DC6431.2020404@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > [...]  What puzzles me
> > (among other things) is why do 5 of the drives show zero reads while 5
> of
> > them show very low levels of read activity, and always the same 5
> drives?
> 
> Can you identify how these drives are connected? If I recall correctly,
> you're using port multipliers (because you have to); is there anything
> like a pattern between the activity of drives and the PMPs or PMP
> channels they're connected to?

'First think of which I thought, of course.  I can't see one.  'Three
different PMPs, with both symptoms present on all 3.  'Both Hitachi and WD
drives with both symptoms.

> To borrow your expression, PMPs have left me with a bad taste in my
> mouth.

'Definitely not my favorite solution, either.  If nothing else, the loss of
a single PMP will at a minimum take the array offline.  At worst, it may
corrupt the drives unrecoverably.  I think this less likely with a
multi-lane controller.

