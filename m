From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Converting Ext3 to Ext3 under RAID 1
Date: Wed, 02 Aug 2006 15:31:43 -0400
Message-ID: <44D0FD9F.9070605@steeleye.com>
References: <200607152056.55090.pwaldo@waldoware.com> <200607230753.47853.pwaldo@waldoware.com> <17603.25777.274507.385333@cse.unsw.edu.au> <200607230832.48807.pwaldo@waldoware.com> <17605.22207.56022.972200@cse.unsw.edu.au> <Pine.LNX.4.61.0608021205110.626@molbio.uoregon.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0608021205110.626@molbio.uoregon.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Graham <graham@molbio.uoregon.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Graham wrote:

>    Is this scheme even half-way sane?

Yes. It sounds correct.

>    Is 16 blocks a large enough area?

Maybe. The superblock will be between 64KB and 128KB from the end of the 
partition. This depends on the size of the partition:

SB_LOC = PART_SIZE - 64K - (PART_SIZE & (64K-1))

So, by 16 blocks, I assume you mean 16 filesystem blocks (which are 
generally 4KB for ext3). So as long as your partition ends exactly on a 
64KB boundary, you should be OK.

Personally, I would err on the safe side and just shorten the filesystem 
by 128KB. It's not like you're going to miss the extra 64KB.

--
Paul
