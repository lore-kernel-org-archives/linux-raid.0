From: Neil Brown <neilb@suse.de>
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Mon, 17 Apr 2006 09:46:46 +1000
Message-ID: <17474.55142.592366.358616@cse.unsw.edu.au>
References: <17467.33725.420883.722623@cse.unsw.edu.au>
	<WM37AD0F023A2040329C1D3276781CBDF0@spsoftindia.com>
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
> Can you provide me details of your setup?

Just a ordinary p4 server with a bunch of SCSI drives.
Running 2.6.17-rc1-mm1, but I doubt that would make a difference.


> Is there any kernel configuration that I will have to change and build my
> kernel with that?
> 

It would really help if you could answer the following questions...


> 
> - What happens if you leave off the "--bitmap=/tmp/bitmap.txt
> --bitmap-chunk=1024"
>   Does it then work?
> 
> - What filesystem is on /tmp
> 
> - Can you give me complete /var/log/messages from before you create
>   the array until this error?
> 

NeilBrown
