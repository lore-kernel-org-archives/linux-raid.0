From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: need help: corrupt files on one of my raids
Date: Tue, 10 Nov 2009 20:16:53 -0800
Message-ID: <4877c76c0911102016k63f3e8ccled2b7f2a5cc3dffd@mail.gmail.com>
References: <4AF97388.5080907@langseid.no>
	 <70ed7c3e0911100734m31cd846t9987d6141d2513a6@mail.gmail.com>
	 <4AF99159.4000800@langseid.no>
	 <70ed7c3e0911101026k5e7ba489s6f3e492acc568d2f@mail.gmail.com>
	 <4AF9CB19.7000803@langseid.no>
	 <70ed7c3e0911101231r9e7e8b0nfcd94a60e5635831@mail.gmail.com>
	 <4AF9D194.6000306@langseid.no>
	 <70ed7c3e0911101829x48e6eb68o892ef11b2ff2d19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911101829x48e6eb68o892ef11b2ff2d19@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

One other thing besides what's already been mentioned.  You are seeing
issues with Raid1 and -not- your Raid5 volume.  If you run mdadm -D
/dev/md(whatever the number is) what version (for the superblock) is
reported?  Preferably you will be using either superblock 1.1 or 1.2
(preferably 1.1).  The only reason to use mdadm 1.0 or 0.9 are special
cases, such as for /boot style volumes.
