From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Tue, 18 Jul 2006 10:56:31 +0200
Message-ID: <fd8d0180607180156p34fc4c6bp3e825c4ee6e443f2@mail.gmail.com>
References: <44BAB76D.9070809@start.no>
	 <17596.15323.451555.218541@cse.unsw.edu.au>
	 <fd8d0180607180117u73aa0259i3cdfcf5580148bc3@mail.gmail.com>
	 <44BC9C20.8060605@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BC9C20.8060605@wasp.net.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Brad Campbell <brad@wasp.net.au>
List-Id: linux-raid.ids

> More likely to produce an output whenever the 1st disk in the array is in the right place as it will
> just look at the 1st couple of sectors for the superblock.
>
> I'd go with the fsck idea as it will try to inspect the rest of the filesystem also.
>

Obviously that's true, but it's still a good way to be sure of the
first disk, and the time cost of the file -s is
neglectible...Personally, I would have done both.
