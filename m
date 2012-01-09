From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: recovery from multiple failures
Date: Sun, 08 Jan 2012 22:23:42 -0800
Message-ID: <eodqt8xo0s.ln2@goaway.wombat.san-francisco.ca.us>
References: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
 <4F0A30CD.60904@turmel.org>
 <fatpt8x1so.ln2@goaway.wombat.san-francisco.ca.us>
 <qa8qt8xi1r.ln2@goaway.wombat.san-francisco.ca.us>
 <20120109161311.77897c30@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-01-09, NeilBrown <neilb@suse.de> wrote:
>
> --assemble --force certainly should start dirty/degraded array.
> There was a bug a while back where it didn't.  Maybe you should try a newer
> mdadm.

I'll try this next time (if there is one).

> Alternately:
>=20
>    echo 1 > /sys/module/md_mod/parameters/start_dirty_degraded=20
>
>
> and try again.  That is an easy way to set the module parameter after the
> module is loaded.

Worked great, the array is rebuilding now.  xfs_repair has found a small
number of errors, but otherwise the filesystem seems fine (at least for
now; haven't mounted it yet).

--keith



-- 
kkeller@wombat.san-francisco.ca.us


