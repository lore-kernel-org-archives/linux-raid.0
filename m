From: Neil Brown <neilb@suse.de>
Subject: Re: raid 5 mismatch_cnt errors
Date: Fri, 21 May 2010 08:38:19 +1000
Message-ID: <20100521083819.54680dfb@notabene.brown>
References: <4BF56B1F.9080205@locallinux.com>
	<20100521071645.497cdcad@notabene.brown>
	<4BF5B7D1.3070808@locallinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BF5B7D1.3070808@locallinux.com>
Sender: linux-raid-owner@vger.kernel.org
To: Trey Scarborough <treys@locallinux.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 20 May 2010 17:29:37 -0500
Trey Scarborough <treys@locallinux.com> wrote:

> Neil Brown wrote:
> > On Thu, 20 May 2010 12:02:23 -0500
> > Trey Scarborough <treys@locallinux.com> wrote:
> >
> >   
> >> I have a raid 5 array with 9 disks and I have a mismatch_cnt that keeps 
> >> growing. This is causing file corruption on the underlaying file systems 
> >> as well.  I can copy a group of 100 100mb files and then do a md5sum on 
> >> them and 1-3 will be corrupt. If this is a drive that is bad is there 
> >> anyway to run a report on the count per drive that these mismatches 
> >> occur. I have run smarttools test and do not see one drive that stands 
> >> out to be causing errors. Could something else be causing these errors?
> >>     
> >
> >
> > When RAID5 detects an inconsistency there is no way to know which device was
> > wrong.
> > SMART only detects some errors, not all.
> > I have had hard drives before which appears to have a single-bit error in
> > their internal buffer.  No error would be reported, but data you read would
> > sometimes be wrong.
> > RAID5 cannot help you with this sort of error.
> >
> > I would suggest backing up all your data (if it isn't already to late),
> > breaking the array, and testing each device individually.
> > e.g. create a filesystem on the device and try copying data on and reading it
> > off.
> >
> > NeilBrown
> >   
> Thats what I was afraid of. The problem I have is if I back it up 
> knowing what data is bad. Luckily it appears to be a write error because 
> once written and correct I can do sums on all the files and I do not see 
> anymore errors. I was thinking that there might be a way of do a resync 
> and turning up the debug somehow so that it would log the mismatches 
> with both the drives that it was reading from at the time. I could then 
> take that information and considering there are 9 drives in the array 
> the one that comes out having the most should be the culprit. I could 
> then remove that drive from the array and test it leaving the rest in a 
> state that could be rebuilt and the data being consistant because the 
> drive with the bad write errors would be removed. Is this something that 
> might be possible?

To detect a mismatch, raid5 reads from all drives in parallel, calculates the
parity across the data blocks and compares that to the parity block.
So no: something like that is not possible.

only thing I can suggest:

- add a write-intent bitmap so you can remove/re-add devices fairly cheaply
- create a v.large file.
- write random data to the file without truncating it. (use dd of=file
  conv=notrunc) then read it back and see if it matches.   If it does, then
  this approach doesn't help.  If it doesn't:

  1 by 1, fail/remove a drive from the array.  Write new random data to the
  same file and read it back and compare.  Then --readd the missing device.
  I'm hoping that you will get an error every time except when the 'bad'
  device has been removed.

NeilBrown
