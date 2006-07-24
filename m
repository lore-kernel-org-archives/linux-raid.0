From: Neil Brown <neilb@suse.de>
Subject: Re: In Trouble--Please Help!  (was Re: Can't add disk to failed raid array)
Date: Tue, 25 Jul 2006 09:24:47 +1000
Message-ID: <17605.22207.56022.972200@cse.unsw.edu.au>
References: <200607152056.55090.pwaldo@waldoware.com>
	<200607230753.47853.pwaldo@waldoware.com>
	<17603.25777.274507.385333@cse.unsw.edu.au>
	<200607230832.48807.pwaldo@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Waldo on Sunday July 23
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 23, pwaldo@waldoware.com wrote:
> Here is the dmesg output.  No log files are created with the FC5 rescue disk.  
> Thanks!
> 
> 
> 
> On Sunday 23 July 2006 07:59, Neil Brown wrote:
> > On Sunday July 23, pwaldo@waldoware.com wrote:
> > > At this point, I'd just be happy to be able to get the degraded array
> > > back up and running.  Is there any way to do that?  Thanks!
> >
> >  mdadm --assemble --force /dev/md1 /dev/hd[aceg]2 /dev/sd[ab]2
> >
....
> raid6: cannot start dirty degraded array for md1

Just checked, and this is fixed in the latest mdadm.  If you use 2.5.2
this --assemble --force will work.

Alternately booting with
  md-mod.start_dirty_degraded=1

or running
  echo 1 >  /sys/module/md_mod/parameters/start_dirty_degraded 

before the --assemble

should work.

NeilBrown
