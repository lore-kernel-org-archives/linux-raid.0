From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 12:41:36 +0200
Message-ID: <46498E60.9060407@wpkg.org>
References: <4649760A.1060805@wpkg.org> <17993.34959.150157.200536@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17993.34959.150157.200536@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown schrieb:

(...)

> An external bitmap means that if the link goes down, it keeps track of
> which blocks are in sync and which aren't, and when the link comes
> back up you re-add the missing device and the rebuild continues where
> it left off.

>   mdadm --build /dev/md22 --level=1 --bitmap=/root/mybitmap \
>      --write-behind --raid-disks=2 /dev/localdevice --write-mostly /dev/remotedevice

One more question - is there a way to estimate the size of the bitmap 
file? Does it depend on the size of the array?

What bitmap file size can I expect for a 600 GB array?


-- 
Tomasz Chmielewski
http://wpkg.org
