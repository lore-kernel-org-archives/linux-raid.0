From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: md software raid
Date: Wed, 28 Oct 2009 13:50:35 +1300
Message-ID: <4AE7955B.3020501@sauce.co.nz>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com> 	<20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com> <70ed7c3e0910271758r3f10b79fw99375299ed721f1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910271758r3f10b79fw99375299ed721f1e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Majed B. wrote:
> Indeed xfs_repair doesn't require the abusive amount of memory
> xfs_check requires.
> 
> I've been a happy XFS user for a few years now, but the fact the
> xfsprogs aren't being maintained properly and xfs_check is still a
> failure, I'm considering other alternatives.

This should change soon, see the September entry:

http://xfs.org/index.php/XFS_Status_Updates

"On the userspace side a large patch series to reduce the memory usage 
in xfs_repair to acceptable levels was posted, but not yet merged."

Regards,

Richard
