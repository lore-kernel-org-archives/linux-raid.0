From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 16:42:57 +0100
Message-ID: <20121125154257.GA4565@lazy.lzy>
References: <10107277.2.1353857505404.JavaMail.root@zimbra>
 <4164037.TSORKSTxib@workstation-home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4164037.TSORKSTxib@workstation-home>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel Hansen <tommyapeldk@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 25, 2012 at 04:36:34PM +0100, Tommy Apel Hansen wrote:
> On Sunday 25 November 2012 16:31:45 Roy Sigurd Karlsbakk wrote:
> > > Hello, personally I would vote for an option to rotate spares into and
> > > array
> > > like Peter suggests, keeping a drive idle doesn't guarrantee that it's
> > > actually operational.
> > 
> > Only problem with this, is if you do it frequently, it'll degrade
> > performance.
> > 
> > Btw, is there a way to replace a drive without failing one? In RAID-5, a
> > common issue is to have a failed drive and then find bad sectors on
> > another. In this setting (and possibly others), it'd be good to have md
> > replace the drive while still active (like what can be done in ZFS).
> 
> Well both options serve a purpose, but say you rotate a spare into the array 
> that then fails on spinup, then you would have a faulted array as your 
> implementation plan states that a drive cannot be "older" than x hours, then 
> you would have and endless loop where as the other option would suggest to 
> zero the former drive and reinstate it.

I do not know if you answered to my message, anyhow
the spare can fail in any case, idle or not.

This is a situation the system should be able to
couple with, for example testing the spare before
starting the hot replace operation.

Which is good in any case.

bye,

-- 

piergiorgio
