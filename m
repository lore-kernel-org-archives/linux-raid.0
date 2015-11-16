From: "John Stoffel" <john@stoffel.org>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 12:32:34 -0500
Message-ID: <22090.4914.784452.360948@quad.stoffel.home>
References: <22090.1097.258820.65463@quad.stoffel.home>
	<20151116182731.Horde.4rj0hKH2I4Q0KSxmbRtF3Es@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151116182731.Horde.4rj0hKH2I4Q0KSxmbRtF3Es@www3.nde.ag>
Sender: linux-raid-owner@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Jens-U" == Jens-U Mozdzen <jmozdzen@nde.ag> writes:

Jens-U> Hi John,
Jens-U> Zitat von John Stoffel <john@stoffel.org>:
>> Guys,
>> 
>> I'm starting to get tons of errors on my various mixed 1 and 2Tb
>> drives I have in a bunch of RAID 1 mirrors, generally triple mirrors.
>> It's time to start replacing them and I think I want to either go with
>> the WD Black 4Tb or the WD Red 4Tb drives.  And with a pair of 500Gb
>> SSDs to use with lvmcache for speedup.
>> 
>> Any comments?

Jens-U> How are the drives to be attached to the server?

I'm planning on just hooking them into the:

  Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008
  PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)

PCIe controller I have in the system.   This is strictly my home
server, not anything special.  Except to me.  :-)

Jens-U> We started with a bunch of 1TB WD Reds (2.5") connected to a
Jens-U> SuperMicro server (2028TP-DECR, with 12 disk bays) via SAS3
Jens-U> extender... bad choice. We saw random hangs under various
Jens-U> loads, letting disks drop out of the RAID6. SuperMicro support
Jens-U> blames the disks as such ("not enterprise-grade"), WD
Jens-U> responded that the SAS extender is the source of trouble,
Jens-U> despite being said to support SATA drives. SCTERC was set to 7
Jens-U> seconds.

This is my other complaint, it's damn hard to know SCTERC support from
the vendor specifications documents.  They're practically useless.  

Jens-U> WD's response matches our own observations: Using the same
Jens-U> drives in a non-extender environment (older SuperMicro
Jens-U> servers) gives us no trouble at all.

Jens-U> We found these WD Reds to be a bit slow, but really liked the
Jens-U> power consumption / heat aspects of the drives and of course
Jens-U> the price per GB. As we paired the disks with SSD caching,
Jens-U> actual disk speed was no issue in our case.

Were you using lvmcache?  How did you like it?  Any problems or
issues?  SSD prices are down enough now to make it really tempting to
just get a pair of big 4Tb drives and then the smaller SSDs for
caching, but I'm concerned about reliability and durability.  Which is
why I tend to triple mirror my RAID1 drives...

