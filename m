From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID-10 with odd number of disks (was Re: Software RAID 0+1 with mdadm.)
Date: Thu, 27 Jan 2005 12:16:31 -0500
Message-ID: <200501271714.j0RHEa911050@www.watkins-home.com>
References: <20050127161927.GK82728@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050127161927.GK82728@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Andy Smith' <andy@lug.org.uk>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It rotates the pairs!
Assume 3 disks, A, B and C.
Each stripe would be on these disks:
A+B
C+A
B+C
A+B
C+A
B+C
...

Maybe not exactly as above, but if not, something similar.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Andy Smith
Sent: Thursday, January 27, 2005 11:19 AM
To: 'linux-raid'
Subject: RAID-10 with odd number of disks (was Re: Software RAID 0+1 with
mdadm.)

On Thu, Jan 27, 2005 at 10:50:43AM -0500, Guy wrote:
> RAID10 will work with an odd number of disks!  If really is cool!

It will?  How?  Does it just make the last mirror "pair" have 3
disks or what?

If so then wouldn't it be better just to not have that disk under
md and use it for someting else?

-- 
> > > The optimum programming team size is 1.
Has Jurassic Park taught us nothing?
 -- pfilandr

