From: Jim Paris <jim@jtan.com>
Subject: Re: filesystem corruption with RAID6.
Date: Fri, 3 Sep 2004 13:06:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040903170627.GA11021@jim.sh>
References: <wxx7jrbo87d.fsf@nommo.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wxx7jrbo87d.fsf@nommo.uio.no>
To: Terje Kvernes <terjekv@math.uio.no>
Cc: linux-raid@vger.kernel.org, hpa@zytor.com
List-Id: linux-raid.ids

>   I've recently started testing RAID6
..
>   I get a lot of I/O errors while reading from the recently
>   populated filesystem.  I've removed the LVs, tested different
>   filesystems (ext3, reiserfs) but the errors always show in the
>   same way.

The RAID6 code has problems.  The author, H. Peter Anvin, has verified
this corruption, but there's no fix available yet.

-jim
