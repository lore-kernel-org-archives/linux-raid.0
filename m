From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 19:43:14 +0200
Message-ID: <20161014174314.GA24243@metamorpher.de>
References: <5800AE09.70608@bluewin.ch>
 <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
 <003401d22635$32b7bc70$98273550$@wnsdev.com>
 <580107FA.40901@bluewin.ch>
 <005501d22640$fc4d6a20$f4e83e60$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <005501d22640$fc4d6a20$f4e83e60$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>
Cc: 'Ramon Hofer' <ramonhofer@bluewin.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 14, 2016 at 10:32:47AM -0700, Peter Sangas wrote:
> I installed Ubuntu 16.04 and used the installer to create a RAID1 some of the mds had bitmaps and some did not.

Small ones (/boot, swap) might not get a bitmap by default.
According to the manpage it needs 100G or larger.

|       -b, --bitmap=
|[...]
|              When  creating  an  array  on  devices which are 100G or larger,
|              mdadm automatically adds an internal bitmap as it  will  usually
|              be beneficial.  This can be suppressed with --bitmap=none .



Regards
Andreas Klauer
