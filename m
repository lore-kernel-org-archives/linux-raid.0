From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: Software RAID-0 striping over Hardware RAID-5
Date: Wed, 22 Sep 2004 17:27:24 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095899244.29081.641.camel@tinny.home.foo>
References: <200409201713.i8KHDxj01473@www.watkins-home.com>
	 <41521782.7030908@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41521782.7030908@nsr500.net>
To: Tim Moore <linux-raid@nsr500.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2004-09-22 at 17:23, Tim Moore wrote:
> >>From what I have read, RAID0 will just go as fast as your slowest disk.
> 
> Almost 2X faster.

writes will be as fast as the slowest disk; reads will be faster.

	Scott

