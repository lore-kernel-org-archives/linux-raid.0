From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Re: New RAID array syncs very slow
Date: Wed, 24 Mar 2004 09:18:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040324081832.GA14512@bluff>
References: <40602BE7.8080705@oddpost.com> <Pine.LNX.4.56.0403232235270.13470@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0403232235270.13470@lion.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>   hdparm -Tt /dev/hde
> 
> too. You ought to get at least 45MB/sec on a modern IDE drive.

On my pc I get:
/dev/hda:
 Timing buffer-cache reads:   128 MB in  1.73 seconds = 73.99 MB/sec
 Timing buffered disk reads:  64 MB in  2.98 seconds = 21.48 MB/sec

On my laptop I get
/dev/hda:
 Timing buffer-cache reads:   596 MB in  2.01 seconds = 296.52 MB/sec
 Timing buffered disk reads:   54 MB in  3.05 seconds =  17.70 MB/sec

On other raid server I have on production I get
/dev/hda:
 Timing buffer-cache reads:   128 MB in  0.24 seconds =533.33 MB/sec
 Timing buffered disk reads:  64 MB in  1.29 seconds = 49.61 MB/sec

Which "line" should be "at least 45MB/sec"? I read the man page for -tT opt
but I know too little of how it works to really understand it.

sandro
*:-)

-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
