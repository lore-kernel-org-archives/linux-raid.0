From: "Jeff Breidenbach" <breidenbach@gmail.com>
Subject: Re: Drives of same model in RAID 1/10 ?
Date: Mon, 24 Jul 2006 14:51:35 -0700
Message-ID: <e03b90ae0607241451n1d03ef34oab06461f84378fc4@mail.gmail.com>
References: <ea34i5$k2a$1@sea.gmane.org>
	 <20060724214359.GV21855@strugglers.net>
Reply-To: jeff@jab.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060724214359.GV21855@strugglers.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The only issue is the obvious one that the manufacturers are usually
> fairly vague about the exact usable size of each disk.  If you
> bought half the disks from one manufacturer and half from another
> then you should be able to pair them up and use the minimum of the
> size of each pair.

In a similar vein, if the drives have different speeds and you may be
wasting some performance. The faster drives may be forced to
sit around waiting for an I/O operation to complete on the slowpoke.

Jeff
