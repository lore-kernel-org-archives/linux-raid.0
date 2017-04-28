From: Phil Turmel <philip@turmel.org>
Subject: Re: How important is SCTERC?
Date: Fri, 28 Apr 2017 08:18:08 -0400
Message-ID: <82b6880d-539b-81a9-08ef-1a5bc3d9752e@turmel.org>
References: <48135126-cd8e-6321-77e6-06ae349ecc03@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48135126-cd8e-6321-77e6-06ae349ecc03@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/27/2017 11:35 PM, Ram Ramesh wrote:
> Experts,
> 
> I ordered a couple of 6TB drives from goHarddrive that claimed to be NAS
> suitable, but SMART shows that they do not support
> scterc. I want to replace two of my 3TB drives with these in mdadm
> raid6. I can get a replacement or return, but want to avoid the hassle,
> if I am not seious danger.

Depends on "serious".  I would return for exchange with proper NAS
drives.  And report the vendor for false advertising.

> I do run tler.sh that sets 180s timeout for drives that do not have
> scterc from /etc/rc.local. Am I putting my data in serious danger? I
> only have videos and tv recordings in this md which can be replaced with
> significant effort (about 12TB of movies and tv shows will take some
> time to copy from my DVDs/BDs)

The 180-second timeout is a band-aid, not a solution.  Keep in mind that
your array will appear to be frozen for up to three minutes any time you
have a URE.  That will have application side-effects and especially
consequences from impatient users.

Phil
