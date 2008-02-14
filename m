From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: transferring RAID-1 drives via sneakernet
Date: Thu, 14 Feb 2008 00:57:56 -0800
Message-ID: <e03b90ae0802140057u1865cb72r28353290b55a6db5@mail.gmail.com>
References: <e03b90ae0802111659v2889dc52kc6eed9dfc9478f9e@mail.gmail.com>
	 <47B1633F.5030403@dgreaves.com>
	 <e03b90ae0802121050t192fba6ai5c10338844a60a05@mail.gmail.com>
	 <47B1ECD2.8070406@redhat.com>
	 <e03b90ae0802121914q595a492ft844bde202bd09a0d@mail.gmail.com>
	 <47B2B91E.6000704@dgreaves.com> <47B33011.4090900@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47B33011.4090900@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Greaves <david@dgreaves.com>, Brendan Conoboy <blc@redhat.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just finished the transfer and it went great. Thanks for all
the advice. I went with the assemble-by-uuid approach in
/etc/mdadm.conf which did very well. Especially since drive
letters danced around quite a bit between reboots. One of the
disks died during transit, and the redundancy part of RAID
earned its keep. The only thing I didn't figure out was SATA
hotplug. The SATA controller (an Areca 1230 in JBOD mode)
happily noticed when a drive was hotplugged into a port. But
Linux didn't seem to notice. I was using cfdisk to probe.
Is there a particular command needed to convince Linux to
look around and see if there are any new SATA devices?

Jeff
