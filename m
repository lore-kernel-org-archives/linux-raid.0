From: Tommy Apel Hansen <tommyapeldk@gmail.com>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 16:36:34 +0100
Message-ID: <4164037.TSORKSTxib@workstation-home>
References: <10107277.2.1353857505404.JavaMail.root@zimbra>
Reply-To: Tommy Apel Hansen <tommyapeldk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10107277.2.1353857505404.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday 25 November 2012 16:31:45 Roy Sigurd Karlsbakk wrote:
> > Hello, personally I would vote for an option to rotate spares into and
> > array
> > like Peter suggests, keeping a drive idle doesn't guarrantee that it's
> > actually operational.
> 
> Only problem with this, is if you do it frequently, it'll degrade
> performance.
> 
> Btw, is there a way to replace a drive without failing one? In RAID-5, a
> common issue is to have a failed drive and then find bad sectors on
> another. In this setting (and possibly others), it'd be good to have md
> replace the drive while still active (like what can be done in ZFS).

Well both options serve a purpose, but say you rotate a spare into the array 
that then fails on spinup, then you would have a faulted array as your 
implementation plan states that a drive cannot be "older" than x hours, then 
you would have and endless loop where as the other option would suggest to 
zero the former drive and reinstate it.

/Tommy
