From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Checking if RAID does work?
Date: Thu, 20 Jan 2005 11:05:42 +1100
Message-ID: <16878.62934.337974.249028@cse.unsw.edu.au>
References: <20050117010355.GH347@unthought.net>
	<200501192217.29258.maarten@ultratux.net>
	<yw1xk6q9xgg6.fsf@ford.inprovide.com>
	<200501192259.46359.maarten@ultratux.net>
	<yw1xfz0xxc9g.fsf@ford.inprovide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from  =?ISO-8859-1?Q?=20M=E5ns?=  =?ISO-8859-1?Q?=20Rullg=E5rd?= on Wednesday January 19
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 19, mru@inprovide.com wrote:
> 
> If the array is stopped, and then the disks tampered with, there is no
> way md is noticing it.  It's possible, however, that md will notice if
> a disk is accessed directly while the array is active.
> 

While theoretically possible, md doesn't notice this.
The closest it comes is in 2.6 where a component drive cannot be
mounted while it is active in an md array (EBUSY).

NeilBrown

