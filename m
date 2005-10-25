From: David Greaves <david@dgreaves.com>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 23:18:27 +0100
Message-ID: <435EAF33.10406@dgreaves.com>
References: <E1EU8w7-0003Bp-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU8w7-0003Bp-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach wrote:

>Individual directories contain up to about 150,000 files. If I run ls
>-U on all directories, it completes in a reasonably amount of time (I
>forget how much, but I think it is well under an hour). Reiserfs is
>supposed to be good at this sort of thing. If I were to stat each
>file, then it's a different story.
>  
>
Have you tried / can you try XFS.

IIRC it is very good indeed at this kind of scenario (used to be an
*excellent* nntp server fs)

David

