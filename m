From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: RAID-5 using CLOOP devices
Date: Tue, 27 Dec 2005 21:30:31 -0500
Message-ID: <20051228023031.GA31926@lug.udel.edu>
References: <6d5bedd80512271108q6dda3d2ax23b226caba823caa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6d5bedd80512271108q6dda3d2ax23b226caba823caa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 27, 2005 at 01:08:32PM -0600, Ewan Grantham wrote:
> I have been successfully using a RAID-5 array under Windows XP using
> the coLinux 0.7 embedded Linux software (colinux.sourceforge.net) with
> a Debian setup and mdadm (and Samba to make the array available to the
> Windows side of the machine).

Wait - so what is the difference?

Right now, you are using md to make a RAID5 of cloop devices, on
something like a virtual environment.

Soon, you'll use md to make a RAID5 of cloop devices, on a total
physical environment.

If it's working now, how could it possibly not work?
Maybe I don't understand the situation...

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
