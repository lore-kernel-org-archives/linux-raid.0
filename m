From: "David Rees" <drees@greenhydrant.com>
Subject: Re: What raid to build on that drives?
Date: Wed, 26 Nov 2003 13:44:59 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2804.208.48.139.163.1069883099.squirrel@www.greenhydrant.com>
References: <3229206566.20031126203657@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3229206566.20031126203657@gmx.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, November 26, 2003 1at 1:36 am, Timo Boettcher wrote:
>
>    I have 3 * 36GB discs and 5 * 18GB discs on two u160 scsi channels?
>    What possibilities do I have to build a raid on them? I want to be
>    able to survive one failed disc, but get as much space and
>    performance out of the discs as possible.

How about two RAID5 arrays, one with the 3*36GB=72GB and the other using
the 5*18GB=72GB.  Then throw both of these under a RAID0 which will get
you 144GB and still be able to survive 1 disk failure.

-Dave
