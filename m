From: Neil Brown <neilb@suse.de>
Subject: Re: RAID10 status when you remove the first disk and last disk
Date: Wed, 21 Jul 2010 13:06:50 +1000
Message-ID: <20100721130650.3b23b960@notabene>
References: <F03AFE7E8C7E644392BE79B102C8B5A50489FCD5@MAIL3.netgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F03AFE7E8C7E644392BE79B102C8B5A50489FCD5@MAIL3.netgear.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Li <michael.li@netgear.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 20 Jul 2010 19:34:06 -0700
"Michael Li" <michael.li@netgear.com> wrote:

> Hi ,
> 
>  
> 
> I am using RAID10 far copy 2 by 4 disks, when I removed the first disk
> and last disk, I think this raid should be failed, but mdadm -D
> /dev/md2, I saw it was degraded, but when I try to read/write, there
> will be I/O error. And when I added the two disks again, the raid will
> be recovery, so that's normal? why it is designed like this?
> 
>  
> 
> Anyone know the detail about that? Thanks so much!
> 

Sounds like a bug.  You have definitely lost data if the first and last
devices of such an array go missing, so it should not try to recover a spare
in to either slot.

What kernel version are you using?

NeilBrown
