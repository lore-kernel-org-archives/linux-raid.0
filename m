From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 14:53:36 -0600
Message-ID: <1125521616.3194.22.camel@x1-6-00-0d-60-fd-e8-4c>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH>
	 <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH>
	 <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH>
	 <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c>
	 <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-08-31 at 14:45, David M. Strang wrote:
> On Wed, 2005-08-31 at 14:39, Forrest Taylor wrote:
> > If you are running 2.4 kernel, did you try running rescan-scsi-bus.sh
> > (http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh)?
> 
> uname -ar
> Linux abyss 2.6.11.12 #2 SMP Thu Jul 21 07:49:40 UTC 2005 i686 unknown 
> unknown GNU/Linux
> 
> Will it work on 2.6?

I thought that it was integrated into 2.6 kernels (I guess that I was
wrong).  In the header of the file, Kurt says that he tested in on a
2.6.11 kernel, so I assume that it would work on a 2.6 kernel ;o)

Forrest

