From: NeilBrown <neilb@suse.com>
Subject: Re: mismatch_cnt constantly goes up on ssd+hdd raid1
Date: Thu, 25 Jun 2015 17:25:30 +1000
Message-ID: <20150625172530.5c5338b6@noble>
References: <3700381434301996@web21o.yandex.ru>
	<20150625113335.7bf72b0b@noble>
	<20150625101959.23981c72@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150625101959.23981c72@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: tlknv <tlknv@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Jun 2015 10:19:59 +0500 Roman Mamedov <rm@romanrm.net> wrote:

> On Thu, 25 Jun 2015 11:33:35 +1000
> NeilBrown <neilb@suse.com> wrote:
> 
> > On Sun, 14 Jun 2015 20:13:16 +0300 tlknv <tlknv@yandex.ru> wrote:
> > 
> > > Hello,
> > 
> > > I have raid 1 which mirrors a root/boot partition on 1SSD and 2HDD
> > > (write-mostly). mismatch_cnt goes up even when there are very few
> > > writes to the partition as /var is mounted separatly. After I update
> > > several packages I typically see mismatch_cnt somewhere between
> > > 500,000 and 2,000,000. I have read a number of threads in this DL
> > > but could not find an explanation of what could cause mismatch_cnt
> > > to grow that much. I checked md5 sums using
> > > /var/lib/dpkg/info/*.md5sums, and didn't see many errors, even
> > > though there are few, mostly in text files which look ok to me. I
> > > guess when I check, all reads go to SSD (as both HDDs in this raid
> > > are write-mostly), and thus md5sum only shows no problem on
> > > SSD. Note, this partition is used as both boot and root and just in
> > > case here is some more info about my system:
> > 
> > This does surprise me.
> > 
> > I had another look at the code and there could be a bug that would let
> > 'check' see the difference between when the first write completes and
> > when the write-behind writes complete, but you would need to run the
> > check while the install was happening for that to be noticed, and even
> > then you would need to be unlucky.
> 
> Couldn't this be simply the normal observed effect of using TRIM on SSD?

Yes, of course it could.  I try not to think about TRIM to much - makes me ill :-)

Thanks,
NeilBrown


> After deleting some files, the filesystem issues a discard request, it
> does nothing to the HDDs, but the content of the discared areas on SSD is no
> longer deterministic (or mostly zeroed, as mentioned in the original report).
> So there is now a mismatch between the content of HDDs and SSD, but since it
> is in the area of deleted files, it doesn't affect the system in any way.
> 

