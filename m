From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: checkarray not running or emailing
Date: Wed, 11 Mar 2020 13:18:11 +0000
Message-ID: <20200311131811.GA30443@cthulhu.home.robinhill.me.uk>
References: <814aad65-fba3-334c-c4df-6b8f4bfc4193.ref@att.net>
 <814aad65-fba3-334c-c4df-6b8f4bfc4193@att.net>
 <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lesrhorer@att.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue Mar 10, 2020 at 08:11:36PM -0500, Leslie Rhorer wrote:

>      Is there seriously no one here who knows how checkarray was 
> launched in previous versions?
> 
> On 3/1/2020 3:03 PM, Leslie Rhorer wrote:
> >     I have upgraded 2 of my servers to Debian Buster, and now neither 
> > one seems to be running checkarray automatically.  In addition, when I 
> > run checkarray manually, it isn't sending update emails on the status 
> > of the job.  Actually, I have never been able to figure out how 
> > checkarray runs.  One my older servers, there doesn't seem to be 
> > anything in /etc/crontab, /etc/cron.monthly, /etc/init.d/, 
> > /etc/mdadm/mdadm.conf, or /lib/systemd/system/ that would run checkarray.

Google suggests it's run from /etc/cron.d/mdadm. Does this exist on your
systems? I'm not sure why upgrading to Buster would have stopped the
checks though, unless the script wasn't replaced and the file location
for checkarray has changed.

Cheers,
    Robin
-- 
     ___        
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |
