From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Strange IO stats on RAID1?
Date: Mon, 4 Sep 2006 05:58:13 -0400
Message-ID: <200609040558.13676.pwaldo@waldoware.com>
References: <44F57FEF.7000400@waldoware.com> <17659.47491.922866.938176@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17659.47491.922866.938176@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 04 September 2006 1:28 am, Neil Brown wrote:
> On Wednesday August 30, pwaldo@waldoware.com wrote:
> > Hi all,
> >
> > I have an IMAP mail server where mail messages are stored on a RAID1
> > array. The access on that array (/dev/md3) has seemed slow, so I did some
> > investigating. "iostat -x /dev/hd[bd] /dev/md3" shows this:
> >
> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >           14.34   47.03   13.99   19.64    0.00    5.00
> >
> > Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s
> > avgrq-sz avgqu-sz   await  svctm  %util hdb          1.05  34.88 35.48 
> > 2.60 1531.23  299.85   765.62   149.93    48.08     0.20    5.38   3.07 
> > 11.69 hdd          0.70  34.83 41.08  2.65  963.12  299.85   481.56  
> > 149.93    28.88     0.15    3.49   1.65   7.24 md3          0.00   0.00
> > 78.31 36.98 2494.35  295.85  1247.18   147.93    24.20     0.00    0.00  
> > 0.00   0.00
> >
> >
> >
> >
> > Here  is my /proc/mdstat for md3:
> >
> > md3 : active raid1 hdb1[0] hdd1[1]
> >       12699264 blocks [2/2] [UU]
> >
> >
> > Observations:
> > - Stats for raw disks writes are similar
> > - Stats for reads on hdd are about half that of hdd
>
> Yes.... odd.
>
> There shouldn't be any bias to one drive or the other.
> When it scans for the best drive to use, it always starts from the
> last one that was used, so there should be no bias to one or the
> other.
>
> I assume they are identical drives?
>   dd if=/dev/hdXX of=/dev/null bs=1024k count=1024
>
> give similar speeds for each?
>
> NeilBrown

Hi Neil,

They are different drives:
root@mail:~# cat /proc/ide/hd[bd]/model
WDC WD205BA
IC35L020AVER07-0

The read speeds are different, 14% by my calculations:
root@mail:~# dd if=/dev/hdb of=/dev/null bs=1024k count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 49.1775 seconds, 21.8 MB/s
root@mail:~# dd if=/dev/hdd of=/dev/null bs=1024k count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 42.3739 seconds, 25.3 MB/s

BTW, my kernel is 2.6.15-26 and mdadm is 1.12.0, running on Kubuntu 6.06.  
Thanks!

Paul

-- 
VGER BF report: H 0.00374821
