From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 16:25:50 +0200
Message-ID: <4CA34C6E.7050804@xunil.at>
References: <4CA300EB.1070909@xunil.at> <4CA30EF5.8020702@seoss.co.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA30EF5.8020702@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 2010-09-29 12:03, schrieb Tim Small:

> Run smartctl -t long, and see what the LBA of the errors are (smartctl
> -a when finished, and look at the error log) - it may be that it is
> outside of the used space (e.g. right at the end of the drive - I've
> seen this in the past) if this is the case, you can just dd over it.
> 
> If the test completes without error then the unreadable sector is either
> not user-addressable, or doesn't really exist, in which case I'd ignore
> it (or perhaps a security-erase will get the drive back into a sensible
> state).  Some of the earlier firmwares for the ST3250310NS were a little
> buggy in my experience, so you might want to look at upgrading it
> (latest Seagate non-OEM firmware is SN06), which can be done with hdparm.

Yep, it finished without error!

Does that mean I could ignore that safely?

Or should I rebuild the raids onto the spare-disk and then swap drive?

S
