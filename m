From: David Greaves <david@dgreaves.com>
Subject: Re: Backups using RAID1
Date: Thu, 20 Nov 2008 11:48:31 +0000
Message-ID: <49254E8F.1000105@dgreaves.com>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com> <20081120090826.GA28736@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081120090826.GA28736@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> Ideally you should unmount the array before failing & removing the
> drive.  If this is not possible then pick a time when the IO is likely
> to be low - there's always going be a risk of corruption (especially
> with something like a database), but modern journalling filesystems
> usually cope with this okay.


If you can't unmount then essentially you want to snapshot the
filesystem/databases - some provide facilities for this.

xfs_freeze springs to mind.

At the very least you could do
sync;mdadm --fail
but that's playing with fire...

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
