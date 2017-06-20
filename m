From: Roman Mamedov <rm@romanrm.net>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Tue, 20 Jun 2017 23:40:14 +0500
Message-ID: <20170620234014.7becb2e8@natsu>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org>
        <87r2yxdazc.fsf@notabene.neil.brown.name>
        <20170620182745.rbufznqe4tuxqttq@merlins.org>
        <20170620183154.GA5303@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170620183154.GA5303@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 20 Jun 2017 11:31:54 -0700
Marc MERLIN <marc@merlins.org> wrote:

> On Tue, Jun 20, 2017 at 11:27:45AM -0700, Marc MERLIN wrote:
> > On Tue, Jun 06, 2017 at 01:57:27PM +1000, NeilBrown wrote:
> > > Had you run "mdadm --examine-bitmap /dev/sdk1" before the re-add, it
> > > would have told you how many bits were set at that time.
> > > 
> > > That "x/y pages" information never should have appeared in /proc/mdstat
> > > - it is really just of interest to developers.  But it is there now, so
> > > removing it is awkward.
> > 
> > So, I got the problem again, re-added a drive that had just been missing
> > for maybe 2mn, and this time I'm getting a very long (but not full)
> > recovery:
>  
> Mmmh, this is puzzling.
> 
> The progress meter was wrong, it recovered in 3mn:
> Jun 20 11:19:28 gargamel kernel: [  916.007017] md: recovery of RAID array md8
> Jun 20 11:22:41 gargamel kernel: [ 1108.395580] md: md8: recovery done.

Yes the progress bar in effect just visualizes the entire drive area, and
thanks to the bitmap md will do syncing only where it needs to, skipping over
the parts which are in sync. So the progress will instantly jump dozens of
percents (skipping hundreds of GBs), stopping only here and there for a while.

-- 
With respect,
Roman
