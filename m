From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: filesystem corruption with RAID6.
Date: Fri, 03 Sep 2004 11:19:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4138B5A6.7070304@zytor.com>
References: <wxx7jrbo87d.fsf@nommo.uio.no> <20040903170627.GA11021@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040903170627.GA11021@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: Terje Kvernes <terjekv@math.uio.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:
>>  I've recently started testing RAID6
> 
> ..
> 
>>  I get a lot of I/O errors while reading from the recently
>>  populated filesystem.  I've removed the LVs, tested different
>>  filesystems (ext3, reiserfs) but the errors always show in the
>>  same way.
> 
> 
> The RAID6 code has problems.  The author, H. Peter Anvin, has verified
> this corruption, but there's no fix available yet.
> 
> -jim

Note: the corruption Jim found and which I have confirmed are only when doing 
large number of writes to a filesystem in degraded mode.  If you see something 
different, please let me know.  It would definitely help tracking this down.

The bug is elusive enough that it's difficult :-/
	
	-hpa

