From: Andy Smith <andy@strugglers.net>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Fri, 29 Aug 2014 20:45:04 +0000
Message-ID: <20140829204502.GT19874@bitfolk.com>
References: <20140825103234.GH11855@bitfolk.com>
 <20140825212614.5be558c9@notabene.brown>
 <20140825113402.GF19874@bitfolk.com>
 <20140829135312.5a6e78bc@notabene.brown>
 <20140829040231.GP19874@bitfolk.com>
 <20140829141812.17c35df7@notabene.brown>
 <20140829042618.GQ19874@bitfolk.com>
 <20140829143528.588cf640@notabene.brown>
 <20140829044226.GR19874@bitfolk.com>
 <20140829160443.3893adaa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140829160443.3893adaa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Fri, Aug 29, 2014 at 04:04:43PM +1000, NeilBrown wrote:
> On Fri, 29 Aug 2014 04:42:26 +0000 Andy Smith <andy@strugglers.net> wrote:
> > In fact I can't increase it by 1, and /bin/echo doesn't say why.
> > 
> 
> Hmm.... I've obviously been assuming something that was wrong.
> 
> So I did some experiments myself....
> 
> If you apply the following patch to mdadm, stop the array, and then assemble
> with --update=devicesize, you should then be able to reshape the array to
> fewer devices.

Thanks, I think we are getting somewhere:

# ./mdadm --stop /dev/md2
mdadm: stopped /dev/md2
# ./mdadm --assemble --update=devicesize /dev/md2
Size was 618726528
Size is 618727392
Size was 618726528
Size is 618727392
Size was 618726528
Size is 618727392
Size was 618726528
Size is 618727392
Size was 618726528
Size is 618727392
Size was 618726528
Size is 618727392
mdadm: /dev/md2 has been started with 6 drives.
# logout
$ head -5 /proc/mdstat
Personalities : [raid1] [raid10]
md2 : active raid10 sdd3[0] sda3[5] sdc3[4] sdb3[3] sdf3[2] sde3[1]
      928089792 blocks super 1.0 64K chunks 2 near-copies [6/6] [UUUUUU]

$ sudo ./mdadm /dev/md2 --grow --raid-devices=4
mdadm: this change will reduce the size of the array.
       use --grow --array-size first to truncate array.
       e.g. mdadm --grow /dev/md2 --array-size 618726528
unfreeze
$ sudo ./mdadm --grow /dev/md2 --array-size 618726528
$ sudo ./mdadm /dev/md2 --grow --raid-devices=4
$ head -5 /proc/mdstat
Personalities : [raid1] [raid10]
md2 : active raid10 sdd3[0] sda3[5] sdc3[4] sdb3[3] sdf3[2] sde3[1]
      618726528 blocks super 1.0 64K chunks 2 near-copies [4/4] [UUUU]
      [>....................]  reshape =  0.0% (211136/618726528) finish=244.1min speed=42227K/sec

> Thanks for your patience.

No problem, glad we got to the bottom of it!

Cheers,
Andy
