From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: very poor ext3 write performance on big filesystems?
Date: Sat, 01 Mar 2008 15:04:29 -0500
Message-ID: <47C9B6CD.3040709@tmr.com>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47C54773.4040402@wpkg.org> <20080227200335.GB9331@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080227200335.GB9331@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@Sun.COM>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andreas Dilger wrote:
> I'm CCing the linux-raid mailing list, since I suspect they will be
> interested in this result.
>
> I would suspect that the "journal guided RAID recovery" mechanism
> developed by U.Wisconsin may significantly benefit this workload
> because the filesystem journal is already recording all of these
> block numbers and the MD bitmap mechanism is pure overhead.
>   

Thanks for sharing these numbers. I think use of a bitmap is one of 
those things which people have to configure to match their use, 
certainly using a larger bitmap seems to reduce the delays, using an 
external bitmap certainly help, especially on an SSD. But on a large 
array, without a bitmap, performance can be compromised for hours during 
recovery, so the administrator must decide if normal case performance is 
more important than worst case performance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


