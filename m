From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Tue, 11 Apr 2006 17:25:24 +0530
Message-ID: <WM37AD0F023A2040329C1D3276781CBDF0@spsoftindia.com>
References: <17467.33725.420883.722623@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17467.33725.420883.722623@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Can you provide me details of your setup?
Is there any kernel configuration that I will have to change and build my
kernel with that?

Thanks,
Yogesh


-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Tuesday, April 11, 2006 3:54 PM
To: Yogesh Pahilwan
Cc: linux-raid@vger.kernel.org
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15

On Tuesday April 11, pahilwan.yogesh@spsoftindia.com wrote:
> Hi Neil,
> 
> When I try the following steps on kernel 2.6.16 I am getting the same
errors
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

- What happens if you leave off the "--bitmap=/tmp/bitmap.txt
--bitmap-chunk=1024"
  Does it then work?

- What filesystem is on /tmp

- Can you give me complete /var/log/messages from before you create
  the array until this error?

Thanks,
NeilBrown

