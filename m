From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Mon, 8 Feb 2010 19:04:14 -0500
Message-ID: <87f94c371002081604g37984161h2ba65bd193714780@mail.gmail.com>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dawning Sky <the.dawning.sky@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> PS, if in the end I have to build a new array, I'll probably go with a
> raid 6 instead.

Agreed, someone recently posted that for a raid-5 composed of 1TB
drives the odds of a rebuild failure are 1 in 67 even if the remaining
drives are within spec.  (ie. the unrecoverable bit error rate is
slowing succumbing to the ever increasing size of drives.)

You have 500GB drives, but you have 3 left to rebuild from, so that's
1.5 TB your trying to read.  I'm not sure how the original calculation
was done, so your odds of failed rebuild were either 1 in 134 or about
1 in 42.  Either not very good for something that is supposed to
protect your data.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
