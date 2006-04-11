From: Neil Brown <neilb@suse.de>
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Tue, 11 Apr 2006 20:23:57 +1000
Message-ID: <17467.33725.420883.722623@cse.unsw.edu.au>
References: <17467.26404.694606.713916@cse.unsw.edu.au>
	<WM1218BC66C6234486A2CA5934C83B258B@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yogesh Pahilwan on Tuesday April 11
Sender: linux-raid-owner@vger.kernel.org
To: Yogesh Pahilwan <pahilwan.yogesh@spsoftindia.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 11, pahilwan.yogesh@spsoftindia.com wrote:
> Hi Neil,
> 
> When I try the following steps on kernel 2.6.16 I am getting the same errors
> as on kernel 2.6.15.
> 
> # mdadm -Cv /dev/md0 --assume-clean --force --bitmap=/tmp/bitmap.txt
> --bitmap-chunk=1024 -l5 -n4 /dev/sd{a,b,c,d}
> 
> Array gets created successfully.
> 
> # mdadm /dev/md0 -f /dev/sda
> mdadm: set /dev/sda faulty in /dev/md0
> 
> # mdadm /dev/md0 -r /dev/sda
> mdadm: hot remove failed for /dev/sda: Device or resource busy

Thanks for testing.
If I do exactly the same sequence it works perfectly.  So there must
be some important different between your setup and mine.

- What happens if you leave off the "--bitmap=/tmp/bitmap.txt --bitmap-chunk=1024"
  Does it then work?

- What filesystem is on /tmp

- Can you give me complete /var/log/messages from before you create
  the array until this error?

Thanks,
NeilBrown
