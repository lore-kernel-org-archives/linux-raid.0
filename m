From: "John Stoffel" <john@stoffel.org>
Subject: Re: errors when reading in one section of a disk
Date: Wed, 25 Jan 2017 10:44:14 -0500
Message-ID: <22664.51150.798851.190164@quad.stoffel.home>
References: <3b82fbda-b3a7-4bcf-8c1e-cbb2b2fd7075@exhybrid01.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3b82fbda-b3a7-4bcf-8c1e-cbb2b2fd7075@exhybrid01.net.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Boylan, Ross" <Ross.Boylan@ucsf.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Ross> I suspect this problem has little to do with RAID, but since I'm
Ross> using it I thought I'd start here.  I have 3 disks in a Vantec
Ross> HX4 4 SATA drive box, connected by USB.  Repeatedly, when I try
Ross> to read certain sectors of one disk every disk in the box seems
Ross> to reset and then get remounted.  I thought this was a transient
Ross> power failure the first time (though I'm on UPS), but when it
Ross> happened again I figured the problem was elsewhere.  I am
Ross> surprised that a read failure on one drive seems to reset the
Ross> entire connection to the box.


Ross> The disk is a relatively new WD Red Pro, and so seems unlikely
Ross> to have a physical failure.  The Vantec box is almost 5 years
Ross> old, and seems a better suspect.  The only reason I can think
Ross> that reading a particular spot on one disk would make it fail is
Ross> that this is perhaps accompanied by some other activity at the
Ross> same time.  The Vantec itself supplies no RAID or anything
Ross> fancy, just access to the drives.

I'd just replace the Vantec box, the USB-SATA bridge is probably A)
slow, and B) flaky.  

