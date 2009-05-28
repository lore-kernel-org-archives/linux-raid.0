From: "Simon Jackson" <sjackson@bluearc.com>
Subject: RE: FW: Detecting errors on the RAID disks.
Date: Thu, 28 May 2009 09:19:04 +0100
Message-ID: <3D76E016F4A2A749A1EB1A3FD83E22BC0285F3A9@uk-email.terastack.bluearc.com>
References: <3D76E016F4A2A749A1EB1A3FD83E22BC0285F2F4@uk-email.terastack.bluearc.com> <4A1D9600.5020109@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <4A1D9600.5020109@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard.

Thanks for the pointer, I shall look at that.  

I am still interested to know what the errors file provides a count of.


Simon.

-----Original Message-----
From: Richard Scobie [mailto:richard@sauce.co.nz] 
Sent: 27 May 2009 20:35
To: Simon Jackson
Cc: linux-raid@vger.kernel.org
Subject: Re: FW: Detecting errors on the RAID disks.

Simon Jackson wrote:
> I have been looking for a way of detecting whether disks used in RAID
sets have had errors that might indicate the drive is failing..  

smartd, while not foolproof, offers some assistence here:

http://smartmontools.sourceforge.net/

Regards,

Richard
