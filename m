From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: Large single raid... - XFS over NFS woes
Date: Tue, 27 Jun 2006 14:05:39 +0200
Message-ID: <200606271405.39829.Dexter.Filmore@gmx.de>
References: <449AEB7C.6040108@cjx.com> <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449BE381.6070000@cjx.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Freitag, 23. Juni 2006 14:50 schrieben Sie:
> Strange that whatever the filesystem you get equal numbers of people
> saying that
> they have never lost a single byte to those who have had horrible
> corruption and
> would never touch it again. We stopped using XFS about a year ago because
> we were getting kernel stack space panics under heavy load over NFS. It
> looks like
> the time has come to give it another try.

I'd tread on XFS land cautious - while I always favored XFS over Reiser (had 
way to many issues in its stable releases after my fancy) it has some 
drawbacks. First, you cannot shrink it. LVM becomes kinda pointless.
But especially with NFS I ran into trouble myself. 
Copying large amount of data sometimes stalls and eventually has locked the 
machine. 
Plus, recently I had some weird filesystem corruption like /root getting lost 
or similar. Running 2.6.14.1 and NFS3.

If performance is not top priority, stick to ext3 and create 2 partitions or 
volume groups.

My 0.02$ 

Dex

P.S.: How about JFS..? Don't know if it can resize or how stable it is, but I 
can't remember hearing more or less ups or downs than about any other 
journaling fs.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
