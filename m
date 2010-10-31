From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: 3T drives and RAID
Date: Sun, 31 Oct 2010 20:05:27 +0100
Message-ID: <201010312005.27547.bernd.schubert@fastmail.fm>
References: <20101030103312.7b5a2107@zealot> <B8.A4.13137.093EBCC4@cdptpa-omtalb.mail.rr.com> <20101031113029.226d9e65@notabene>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101031113029.226d9e65@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, 'Johannes Truschnigg' <johannes@truschnigg.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday, October 31, 2010, Neil Brown wrote:
> On Sat, 30 Oct 2010 04:21:16 -0500
> 
> "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> > 	Md will automatically treat the oddball drive as if it had .5K
> > 
> > sectors, or does one need to tell ma (or the kernel) to do so?
> 
> You don't need to tell the kernel to do anything special - it should just
> work.
> 
> md/raid5 (and raid6) do all writes as 4K blocks, 4K aligned (as the
> stripe-cache is made of pages which are 4K).  So that fits perfectly with
> the new drives.
> If your filesystem issued a non-aligned read, then it could get down to the
> device as a non-aligned read, but there is little performance penalty for
> reads, only writes.
> And XFS almost certainly does all IO in 4K multiples, so you should be
> fine.
> 
> In short: I can see no reason why it shouldn't work smoothly.

Well, I think alignment on a larger basis is something we need to discuss 
about. I have a modified blkiomon on my disk, which shows IO sizes (will send 
the patches to the corresponding list, once I find the time to finalize it).

On one shell:
bathl:~# dd if=/dev/md5 of=/dev/null bs=1M iflag=direct

On  another shell:

bathl:~# blktrace -d /dev/sdc  -d /dev/sdd -a issue -a complete  -o - \| 
/tmpa/devel/blktrace/blktrace-1.0.1/blkiomon -I10 -h -

sizes histogram (kiB):
           32:   470
          124:  3096
          496:   166


(I modified blkiomon not to print the histogram based on doubled IO sizes, but 
to print multiple of 4K and to skip sizes with zero requests).

Well, I think I need to make an option to print it on the basis of 512B, but 
already the present output shows rather bad IO requests. One thing I have 
learned during my work at DDN is that good performance numbers only can be 
achieved if large IO requests come in. Now a DDN hardware raid is certainly 
not comparable with linux software raid, but if the local disk can do 512KB 
requests and gets that with direct io, linux md should do the same.

The same for a read from sdc:

bathl:~# dd if=/dev/sdc of=/dev/null bs=1M iflag=direct

blktrace -d /dev/sdc  -d /dev/sdd -a issue -a complete  -o - \| 
/tmpa/devel/blktrace/blktrace-1.0.1/blkiomon -I10 -h -

sizes histogram (kiB):
          512:  1874


md5 : active raid10 sdc[0] sdd[1]
      976760832 blocks super 1.2 1024K chunks 2 offset-copies [2/2] [UU]
      bitmap: 0/15 pages [0KB], 32768KB chunk


Cheers,
Bernd



