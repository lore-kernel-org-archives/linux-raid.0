From: Neil Brown <neilb@suse.de>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 14:32:11 +1000
Message-ID: <17995.56011.742143.418388@notabene.brown>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
	<17995.49602.427417.500049@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B3428@gazelle.ad.endace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Jeff Zheng on Thursday May 17
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Zheng <Jeff.Zheng@endace.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 17, Jeff.Zheng@endace.com wrote:
> I tried the patch, same problem show up, but no bug_on report
> 
> Is there any other things I can do?
> 

What is the nature of the corruption?  Is it data in a file that is
wrong when you read it back, or does the filesystem metadata get
corrupted?

Can you try the configuration that works, and sha1sum the files after
you have written them to make sure that they really are correct?
My thought here is "maybe there is a bad block on one device, and the
block is used for data in the 'working' config, and for metadata in
the 'broken' config.

Can you try a degraded raid10 configuration. e.g.

   mdadm -C /dev/md1 --level=10 --raid-disks=4 /dev/first missing \
   /dev/second missing

That will lay out the data in exactly the same place as with raid0,
but will use totally different code paths to access it.  If you still
get a problem, then it isn't in the raid0 code.

Maybe try version 1 metadata (mdadm --metadata=1).  I doubt that would
make a difference, but as I am grasping at straws already, it may be a
straw woth trying.

NeilBrown
