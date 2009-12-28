From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: why md/raid5 dont have bad block remap
Date: Mon, 28 Dec 2009 12:28:36 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912281227110.27231@uplift.swm.pp.se>
References: <de04351e0912280303m16a6eac6mf0adad8cd48fc188@mail.gmail.com>  <alpine.DEB.1.10.0912281204480.27231@uplift.swm.pp.se> <de04351e0912280325g3784dc91g26ee0593a6cef439@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de04351e0912280325g3784dc91g26ee0593a6cef439@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: linux-raid@vger.kernel.org, zhenchengjin@163.com, neilb@suse.de
List-Id: linux-raid.ids

On Mon, 28 Dec 2009, jin zhencheng wrote:

> I think maybe the disk deal with one write comnd with errror,but  the
> disk maybe is also ok,and rewrite to other place or  rewrite again
> will be good.
>
> why one write error ,set the whole disk faulty.

If the disk has *WRITE* errors, something is seriously wrong. Read errors 
is one thing, write errors is completely different.

> Disk if very expensive!

Most drives have at least 2-3 years warranty and that should be used. If 
the drive has write errors, then it's really time to replace it, it won't 
be reliable.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
