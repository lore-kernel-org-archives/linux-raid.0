From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: hostRAID, AIC-7901, disable?
Date: Wed, 15 Dec 2004 13:15:10 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B87D965@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I used to have a set of HostRAID cards, the setting to disable HostRAID
was in the Cntl+A configuration under the SCSI section. Thing can change
in a year though ...

The effect of the configuration change is to alter the PCI config space
of the adapter so that it affects which driver attaches to the
controller.

Sincerely -- Mark Salyzyn

On Mon, 2004-12-13 at 21:15 +0000, murray evans wrote:
> Colin McDonald wrote:
> 
> > Cntl+A into the SCSI bios & disable it.
> > 
> > Try that.
> > 
> > 
> 
> 
> Like I say, the setup tool has no option to disable it. this includes 
> both the bios, the the Adaptec SCSISelect tool (i.e. Ctrl A). Although
> the instructions do insist it is there, we've had a very thorough
look,
> and it's not.
