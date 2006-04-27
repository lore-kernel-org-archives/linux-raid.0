From: Al Boldi <a1426z@gawab.com>
Subject: Re: Two-disk RAID5?
Date: Thu, 27 Apr 2006 07:15:43 +0300
Message-ID: <200604270715.43531.a1426z@gawab.com>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com> <Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org> <17487.63969.767902.768109@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17487.63969.767902.768109@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> (*) The term 'mirror' for raid1 has always bothered me because a
> mirror presents a reflected image, while raid1 copies the data without
> any transformation.
>
> With a 2drive raid5, one drive gets the original data, and the other
> drive gets the data after it has been 'reflected' through an XOR
> operation, so maybe a 2drive raid5 is really a 'mirrored' pair....
> Except that the data is still the same as XOR with 0 produces no
> change.
> So, if we made a tiny change to raid5 and got the xor operation to
> start with 0xff in every byte, then the XOR would "reflect" each byte
> in a reasonable meaningful way, and we might actually get a "mirrored
> pair"!!!
>
> But I don't think that would provide any real value :-)

Why not?

Consider disks w/ 100mb/s thruput (theoretical):
2disk raid0 stripes data to yield 200mb/s read/write thruput.
2disk raid5 stripes data to yield 100mb/s write, 200mb/s read thruput always.
2disk raid1 mirrors data to yield 100mb/s write, 100/200mb/s single/multiple 
read thruput only.

Would you think that this is enough of a real value?

Thanks!

--
Al

