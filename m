From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm feature suggestion
Date: Tue, 6 May 2008 12:45:24 +1000
Message-ID: <18463.50756.193011.129733@notabene.brown>
References: <481EF5A5.3030501@serverleih.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Denis Klimek on Monday May 5
Sender: linux-raid-owner@vger.kernel.org
To: Denis Klimek <denis@serverleih.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 5, denis@serverleih.de wrote:
> Hello,
> 
> I've written a "mdadm2sms", which sends me SMS to my mobilephone when 
> something happens to raid.
> Yesterday I've got a sms / also written into syslog (standard), that a 
> rebuild has been started, just for data-checking. My suggestion is now, 
> it is possible to add 3 more Events just for this DataCheck event? Like 
> DataCheckStarted, CheckStarted, CheckedFinished and Check20-100 or 
> something? Cause the problem is, you can't trigger a regulary 
> mdadm-datacheck without using syslog. It would be very nice, when it 
> would be possible to trigger a Datacheck with a event command.
> 

I'm sorry, but I don't understand what you are asking for.

When a data-check is run, it should generate events just like when a
resync or recovery is run.  These will be passed to any --program that
you give to mdadm --monitor.
In that program you can differentiate between
data-check/resync/recovery by looking in /proc/mdstat.

Do you want the events to be different for the different types of
'resync' (check/sync/recover)??  So you can get an SMS on a resync
start but not on a data-check start?  Is that it?

I don't understand
  "It would be very nice, when it would be possible to trigger a
  Datacheck with a event command. "
at all.  How would an event command trigger a Datacheck???


confused.

NeilBrown
