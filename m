From: David Greaves <david@dgreaves.com>
Subject: Re: Can't mount after mkfs -b 8192
Date: Fri, 04 Jun 2004 10:14:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C03D68.2060900@dgreaves.com>
References: <200406040127.i541RB316590@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406040127.i541RB316590@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

>Don't know about your mount issue, but I did notice 4096 in you dmesg,
>should it be 8192?  I did not see any mount options for block size.
>
>sh-2011: read_super_block: can't find a reiserfs filesystem on (dev
>dm-0, block 16, size 4096)
>  
>
Yep
I got a response on the reiser list that prompted me to try XFS.

It rather nicely said:
XFS: Attempted to mount file system with blocksize 8192 bytes
XFS: Only page-sized (4096) or less blocksizes currently work.
XFS: SB validate failed

David
PS http://www.namesys.com/mkreiserfs.html says :
   -b | --block-size N
   N is block size in bytes. It may only be set to a power of 2 within 
the 512-8192 interval.

So that might help googlers in the future ;)
