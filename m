From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re:
Date: Thu, 12 Jan 2006 12:20:38 -0500
Message-ID: <20060112172038.GA12426@lug.udel.edu>
References: <20060111144943.93BAA396A20@mxo3.broadbandsupport.net> <43C63A94.2020702@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43C63A94.2020702@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: bhess@patmedia.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 12, 2006 at 11:16:36AM +0000, David Greaves wrote:
> ok, first off: a 14 device raid1 is 14 times more likely to lose *all*
> your data than a single device.

No, this is completely incorrect.  Let A denote the event that a single
disk has failed, A_i denote the event that i disks have failed.
Suppose P(A) = x.  Then by Bayes's Law the probability that an n disk RAID
will lose all of your data is:

n_1 = P(A) = x
n_2 = P(A_2) = P(A) * P(A_1 | A) = x^2
n_3 = P(A_3) = P(A) * P(A_2 | A) = x^3
...
n_i = P(A_i) = P(A) * P(A_{i-1} | A) = x^i

ie, RAID1 is expoentially more reliable as you add extra disks!

This assumes that disk failures are independant - ie, that you
correctly configure disks (don't use master and slave on an IDE
channel!), and replace failed disks as soon as they fail.

This is why adding more disks to a RAID1 is rare - x^2 is going to be
a really low probability!  It will be far, far more common for
operator error to break a RAID than for both devices to honestly fail.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
