From: Al Boldi <a1426z@gawab.com>
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 15:22:17 +0300
Message-ID: <200707201522.17270.a1426z@gawab.com>
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070720113914.GJ22998@lug-owl.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Jan-Benedict Glaw wrote:
> On Fri, 2007-07-20 14:29:34 +0300, Al Boldi <a1426z@gawab.com> wrote:
> > But, I want something much more automated.  And the partition table
> > backup per partition entry isn't really a bad idea.
>
> That's called `gpart'.

Oh, gpart is great, but if we had a backup copy of the partition table on 
every partition location on disk, then this backup copy could easily be 
reused to reconstruct the original partition table without further 
searching.  Just like the NetWare approach, and in some respect like the 
ext2/3 superblock backups.


Thanks!

--
Al

