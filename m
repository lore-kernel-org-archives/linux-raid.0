From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 19:01:52 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211251900390.27834@uplift.swm.pp.se>
References: <10107277.2.1353857505404.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10107277.2.1353857505404.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Tommy Apel Hansen <tommyapeldk@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 25 Nov 2012, Roy Sigurd Karlsbakk wrote:

> Btw, is there a way to replace a drive without failing one? In RAID-5, a 
> common issue is to have a failed drive and then find bad sectors on 
> another. In this setting (and possibly others), it'd be good to have md 
> replace the drive while still active (like what can be done in ZFS).

That is what "want_replacement" does. You need 2.6.33 or later however.

<http://pl.digipedia.org/usenet/thread/19071/39605/> is the thread for 
someone else who asked similar question.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
