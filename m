From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 14:59:15 -0600
Message-ID: <1125521955.3194.26.camel@x1-6-00-0d-60-fd-e8-4c>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH>
	 <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH>
	 <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH>
	 <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c>
	 <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH>
	 <009601c5ae6e$04d4d5e0$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <009601c5ae6e$04d4d5e0$c100a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-08-31 at 14:53, David M. Strang wrote:
> 
> The output is odd... It only sees 7 of the 28 devices.

It looks like the script only checks for devices 0-7
(idsearch=`seq 0 7`)

It looks like you can pass it a values for the number of devices:

./rescan-scsi-bus.sh -ids=27

See if that finds all devices.

Forrest

