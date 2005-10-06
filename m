From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: RAID 6 corruption : please help!
Date: Thu, 6 Oct 2005 17:33:44 +0200
Message-ID: <62b0912f0510060833i21317a3eg8dc06bfd9883cf7b@mail.gmail.com>
References: <20051005152638.GA24382@pog.tecnopolis.ca>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051005152638.GA24382@pog.tecnopolis.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Trevor Cordes <trevor@tecnopolis.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Trevor Cordes wrote:
> I know all the data is just sitting there, there's just some wackiness to
> the way it's been spread across the disks.

What's stopping you from just pulling out the two new disks, mounting
the array using the old, almost OK disks, and fsck'ing your way out of
the couple of files that were corrupted when you were in rw mode?
