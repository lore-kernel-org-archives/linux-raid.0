From: Marc MERLIN <marc@merlins.org>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Tue, 20 Jun 2017 11:31:54 -0700
Message-ID: <20170620183154.GA5303@merlins.org>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org> <87r2yxdazc.fsf@notabene.neil.brown.name> <20170620182745.rbufznqe4tuxqttq@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170620182745.rbufznqe4tuxqttq@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 20, 2017 at 11:27:45AM -0700, Marc MERLIN wrote:
> On Tue, Jun 06, 2017 at 01:57:27PM +1000, NeilBrown wrote:
> > Had you run "mdadm --examine-bitmap /dev/sdk1" before the re-add, it
> > would have told you how many bits were set at that time.
> > 
> > That "x/y pages" information never should have appeared in /proc/mdstat
> > - it is really just of interest to developers.  But it is there now, so
> > removing it is awkward.
> 
> So, I got the problem again, re-added a drive that had just been missing
> for maybe 2mn, and this time I'm getting a very long (but not full)
> recovery:
 
Mmmh, this is puzzling.

The progress meter was wrong, it recovered in 3mn:
Jun 20 11:19:28 gargamel kernel: [  916.007017] md: recovery of RAID array md8
Jun 20 11:22:41 gargamel kernel: [ 1108.395580] md: md8: recovery done.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
