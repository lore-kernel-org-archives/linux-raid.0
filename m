From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: mismatch_cnt of 128 and 1408.
Date: Mon, 24 Mar 2008 21:23:47 +0100
Message-ID: <20080324212347.32d47553@ors>
References: <20080324083651.444cbab3@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080324083651.444cbab3@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mon, 24 Mar 2008 08:36:51 +0100 schrieb Janek Kozicki:
> 
> Now I am alarmed that something might be wrong with the root
> partition. From other posts I remember that mismatch count for swap
> partitions is allowed to be nonzero.

Apparently it can also happen when a file is truncated between the
writes to the individual disks:
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07546.html

Or could it just be that it was writing when the power failed?

> 
> I checked smart health status of HDDs with smartctl -H and the drives
> are healthy.
> 
> 
> Is mismatch count = 128 an indication of bad HDD? How to discover
> which one is bad?
> 

You could run a long SMART selftest. If the downtime doesn't matter,
you could also boot from a live cd and run badblocks -n.

-- 
Oliver
