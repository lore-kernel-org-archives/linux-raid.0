From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Re: Online resize
Date: Wed, 12 Mar 2008 13:17:08 +0200
Message-ID: <200803121317.09206.wayne@flashmedia.co.za>
References: <200803111119.56015.wayne@flashmedia.co.za> <200803121114.27080.wayne@flashmedia.co.za> <47D7A491.9020205@msgid.tls.msk.ru>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47D7A491.9020205@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 12 March 2008 11:38:25 Michael Tokarev wrote:
> Wayne Gemmell wrote:
> > On Wednesday 12 March 2008 10:04:56 you wrote:
> >> a) re-create the array with new partitions, with THE SAME DISK ORDER,
> >>    METADATA VERSION AND CHUNK SIZE as it was before.
> >
> > Is this possible without loosing data?
>
> Yes.  But it's unreliable, sorta.  Too easy to screw things up, that is.
Thankfully I didn't need to do this. Resizing the partitions fixed that.
And now for the dangerous (looking) part.

> And now, the original question comes up again: what to do, how to
> perform the actual resize of the raid array...
>
> To be fair, I don't really know.  I always used my own tiny program
> to assist me in a situation like this - to back up and restore
> v0.90 linux raid superblocks.  It's available at
> http://www.corpit.ru/mjt/mdsuper.c .  Here's how I use it:
>
> First, save the original superblocks in files:
>
>   for f in sd{a,b,c,d,e}1; do
>     ./mdsuper read /dev/$f > $f
>   done
>
> this instructs mdsuper to read the superblock (v0.90 only!) and
> write it to standard out.  This has to be done while the array
> (on original partitions) is STOPPED.
>
> Now, resize the partitions, reboot if necessary (for the kernel
> to recognize the new sizes).  You can save a dump of your current
> partitions using `sfdisk -d' (redirect its output to a file as
> with mdsuper) - just in case if something goes wrong.
>
> At this point, your array is unaccessible - mdadm will tell you
> that it can't find the superblocks.  But we have the superblocks
> saved - so we only need to restore them back:
>
>   for f in sd{a,b,c,d,e}1; do
>     ./mdsuper write /dev/$f < $f
>   done
>
> (note the redirection is opposite!, and read was changed to write!).
>
> Now, try to assemble the array - it should be here.  We just moved
> (actually copied) the superblock from the now-middle-of-partitions
> to the end, where it should be, and mdadm is now able to find it.
> The array is still of the old size - but now mdadm --grow will
> work.
>
> That's basically it.  Just watch the mdsuper invocation.
>
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards
Wayne Gemmell
Flash Media Group
Tel:	27 (0)12 430 7597
Cell:	27 (0)83 666 3342
