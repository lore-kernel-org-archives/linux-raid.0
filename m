From: Brendan Conoboy <blc@redhat.com>
Subject: Re: "raid" versions of hard drives for software raid?
Date: Wed, 02 Jul 2008 15:30:24 -0600
Message-ID: <486BF370.2070401@redhat.com>
References: <873amsqbag.fsf@uwo.ca> <486BE720.3090507@redhat.com> <alpine.DEB.1.10.0807021650460.7957@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807021650460.7957@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Dan Christensen <jdc@uwo.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> That's a lot of RMA's, bad PSU or vibration issues, or a bad lot of drives?

My educated case is that it was a bad batch of drives (Bought them 
sooner after their introduction).  Drives in the enclosure from other 
MFR's have held up reliably and heat has been a non-issue.

Dan might want to see if hdparm has a tunable for the TLER setting he's 
concerned about.  Modern mdadm versions will attempt to rewrite a sector 
if there's a read error using parity or mirrors to reconstruct the data. 
  For this purpose having a short timeout before getting an error would 
be preferable to waiting a couple minutes.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
