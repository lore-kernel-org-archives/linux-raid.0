From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: PCI ATA EIDE cards and kernel drivers
Date: Wed, 23 Apr 2008 13:12:47 -0400
Message-ID: <480F6E0F.80702@tmr.com>
References: <alpine.LFD.1.10.0804220658410.31467@www.karsites.net> <18446.50.8995.663510@sail.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18446.50.8995.663510@sail.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Keith Roberts <keith@karsites.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
> I find the cost of CD-R media and DVD+R, as well as the issues with
> longevity, to be my biggest concerns.  For those types of media,
> having a very robust and redundant easy to recover format would be
> key.  Haven't seen it done yet, though it's been talked about.  An
> Archive filesystem, not a general access one.  
>   

Let me make one comment on that. To back up files of reasonable (<1GB) 
files, you can build a list of files which will fit on a single DVD (a 
series of lists actually), and backup the files to a DVD, either in ISO 
format or using the loopback mount to make an ext2 filesystem you can 
write to a DVD, or a tar, cpio, you get the idea. The tool to make the 
lists of files which will fit is "breaker" and is on 
www.tmr.com/~public/source for your enjoyment.

The other tool is dvdisaster, which builds software ECC for images you 
are going to burn. You can make DVDs with 3.3GB data + ECC on each DVD, 
or 4.4GB data per DVD and keep the ECC files separately, whatever 
pleases you.  The recovery mode does work, I used scissors to scratch a 
DVD with my initials, then recovered the data.

Both programs have enough documentation for most users.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


