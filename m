From: Luca Berra <bluca@comedia.it>
Subject: Re: Need help for the installation of RAID1 on Rtlinux
Date: Sat, 25 May 2002 11:26:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020525092635.GA2654@colombina.comedia.it>
References: <3CEF340A.EC2CED2@del3.vsnl.net.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CEF340A.EC2CED2@del3.vsnl.net.in>
To: Abacus <abacus@del3.vsnl.net.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please, refer to the linux-raid mailing list for question about
raid software.
Be sure to include any relevant lines of syslog and the output
of cat /proc/mdstat

Regards,
Luca

On Sat, May 25, 2002 at 12:19:46PM +0530, Abacus wrote:
> Sir,
>     We are having a problem with the installation of  "Raid-1" on
> Rtlinux .
>     We followed the following steps for our requirement :-
> 
> 1) We installed  Linux 6.2 OS on a Pentium -III PC with two Hard Disks.
> 2) Then we installed the rtlinux with the Raid-1 support enabled.
> 3) After the rtlinux compilation, we made the partitions for the Raid
> support and made the md0, md1 and md2 partitions.
> 4) Then we changed the partition types of partitions under md0, md1 to
> fd (Raid AutoDetect)
> 5) Then we used the command "mkraid /dev/md0" and got the following
> output along with the error message :-
> 
> handling MD device /dev/md0
> analyzing super-block
> disk 0 : /dev/hda7 , 1887606 KB , raid superblock at 1887488 KB
> disk 1 : /dev/hdc7 , 1887606 KB , raid superblock at 1887488 KB
> 
> mkraid : aborted , see syslog and /proc/mdstat for potential clues.
> 
> 
> 
> 
> We would be highly thankful to you, if you can try to help us out.
> 
> 
> Waiting for your response,
> Yours Faithfully ,
> Mandeep Singh Dang.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
