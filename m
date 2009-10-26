From: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Subject: Re: Is My Data DESTROYED?!
Date: Mon, 26 Oct 2009 09:38:07 -0600 (MDT)
Message-ID: <alpine.DEB.1.00.0910231744410.3525@darius>
References: <406994.2318.qm@web38805.mail.mud.yahoo.com> <4AE22E28.207@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE22E28.207@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Oct 2009, Bill Davidsen wrote:

> adfas asd wrote:
>> I can't find anything about a dry-run or test option in the man page for 
>> mkfs.jfs .
>> 
>
> You want fsck (check my filesystem) not mkfs (blow away all I have and create 
> a new empty filesystem).

I think he wants to know where the mkfs put the backup superblocks
when the filesystem was made originally.  If you know where the backup
superblocks are, you can tell mount to use one of them.  This is one way to recover from a corrupt superblock.

The way I've done this in the past was to issue mkfs with a flag (-n,
I think) that meant, "don't make the filesystem, just tell me what you
would do".  One of the thing that mkfs (actually, this was newfs on
SunOS 4.1.x, which constructs a mkfs command for you) spits out on
stdout is the list of backup superblocks.

-- 
Darius S. Naqvi
dnaqvi@datagardens.com
http://www.datagardens.com
