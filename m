From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Growing a single disk into a 2 disk raid0
Date: Fri, 28 Jan 2011 13:19:16 -0500
Message-ID: <4D4308A4.5000800@cfl.rr.com>
References: <4D42FA3E.6000206@cfl.rr.com> <4D4302B6.2090208@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4302B6.2090208@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: Berkey B Walker <berk@panix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/28/2011 12:53 PM, Berkey B Walker wrote:
> Because 1) I'm old, and 2) I don't trust documentation, I do it the
> slow, easy way.  I use the blank disk and make a RAID missing a disk.  I
> then copy the data to the RAIDed disk.  If everything is OK, zero out
> the old data disk and add it to the raid (filling the "missing").  I do
> it this way any time I want to make  raid  of a disk full of data, to
> any level of raid.

That works for raid1, but as I said, mdadm will not let you create a
single disk raid0.
