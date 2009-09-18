From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Fri, 18 Sep 2009 14:02:10 -0400
Message-ID: <87f94c370909181102y25ee0ba9o833ea2f9c09ff8d7@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org>
	 <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
	 <h8nfoe$n8p$3@ger.gmane.org>
	 <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	 <h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain>
	 <1253106813.17888.9.camel@localhost>
	 <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
	 <1253273738.9662.636.camel@kiste> <4AB3C6E0.7010908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB3C6E0.7010908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

I keep forgetting to ask, but the subject of this thread makes me
wonder if you guys are familiar with the hdparm features of
"--make-bad-sector", "--read-sector", and "--write-sector".

I don't know if any of those can be used to force a sector to be
remapped, but I could see a user space process like:

identify corrupt sector
hdparm --make-bad-sector   (to get it as corrupt as linux knows how).
calculate correct value
write new value to sector the normal way (hopefully the drive will
remap the bad sector)

hdparm --read-sector will do a low level read of the sector, including
the sector header and checksum as I understand it.  I'm not sure all
that gets back to userspace.

hdparm --write-sector will force a sector to be rewritten.  I don't
believe it is meant to ever cause a sector remap.  Of course you never
know what a disk drive is going to do for any given command.

Mark Lord is of course the expert on all things hdparm.

Greg
