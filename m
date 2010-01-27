From: Luca Berra <bluca@comedia.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then
	disaster !!
Date: Wed, 27 Jan 2010 08:41:38 +0100
Message-ID: <20100127074138.GA9607@maude.comedia.it>
References: <4B5F6C73.30707@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B5F6C73.30707@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 26, 2010 at 11:28:03PM +0100, Giovanni Tessore wrote:
> Is this some kind of bug?
No
> Is there any way to configure raid in order to have devices marked faulty 
> on read errors (at least when they clearly become too many)?
I don't think so
> This could (and for me did) bring to big disasters!
Don't agree with you, you had all the info from syslog
You should have run smart tests on the disks and proactively replace a
failing disk.

> In a post of some months ago of a person who had a similar problem, I read 
> as reply that ignoring the read errors is the wanted behaviour of md ... 
> but I can't believe this!!

it does _not_ ignore read errors 
in case of read errors mdadm rewrites the erroring sector, and only if
this fails it will kick the member out of the array.
with modern drives it is possible to have some failed sector, which the
drive firmware will reallocate on write (all modern drives have a range
of sectors reserved for this very purpose)
mdadm does not do any bookkeeping on reallocated_sector_count per drive
the drive does. the data can be accessed with smartctl
drives showing excessive reallocated_sector_count should be replaced.

Consider the following scenario:
raid5 (sda,b,c,d)
sda has a read error, mdadm kicks it immediately from the array
a few minutes/hours later sdc fails completely
lost data and no time to react, that is far worse than having 50 days of
warnings and ignoring them.


L.

I'm sorry for your data, hope you had backups.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
