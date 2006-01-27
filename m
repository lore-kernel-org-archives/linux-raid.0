From: Neil Brown <neilb@suse.de>
Subject: Re: Live Read Error Correction W/O Reconstruct?
Date: Fri, 27 Jan 2006 12:09:39 +1100
Message-ID: <17369.29395.507486.651011@cse.unsw.edu.au>
References: <20060124041452.68243.qmail@web35804.mail.mud.yahoo.com>
	<17365.43840.355844.214204@cse.unsw.edu.au>
	<Pine.LNX.4.64.0601270054280.30583@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Friday January 27
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: mdw1103 <mdw1103@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday January 27, raid@a2000.nu wrote:
> On Tue, 24 Jan 2006, Neil Brown wrote:
> 
> > On Monday January 23, mdw1103@yahoo.com wrote:
> >> In 2004, Mr Brown wrote that read errors could be
> >> handled without reconstruction. Has this been
> >> implemented in 2.6.8? As I understand it,  this is the
> >> way RAID is supposed to work.
> >>
> >
> > Not in 2.6.8.
> > It is implemented in 2.6.15 for raid5 and
> > 2.6.16-rc1 for raid1 and raid6.
> 
> Neil,
> 
> is there anything logged in case this read error occurs ?
> (which can be fixed)

Hmmm...

For raid1, you just get:
  raid1: sdXX: resheduling sector 12345678
with no
  raid1: Disk failure on sdXX, disabling device.
following it.

For raid5 you get
   raid5: read error corrected!!
or
   raid5: read error NOT corrected!!
or
   raid5: read error NOT correctable.

with no mention of which device or sector.

I guess that could be improved, couldn't it ;-)

Thanks,
NeilBrown
