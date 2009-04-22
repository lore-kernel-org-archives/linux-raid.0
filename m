From: Andrew Burgess <aab@cichlid.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Wed, 22 Apr 2009 09:06:54 -0700
Message-ID: <1240416414.10178.1.camel@cichlid.com>
References: <18919.64597.426128.498393@notabene.brown>
	 <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
	 <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it>
	 <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it>
	 <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown>
	 <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it>
	 <20090421181519.GA4114@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090421181519.GA4114@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-04-21 at 20:15 +0200, Piergiorgio Sartor wrote:

> This might be a Fedora 10 issue, so maybe Doug would like
> to comment.
> 
> After reboot, someone, I guess udev, tries to automagically
> start a RAID, so it assembles /dev/md_d127 with one of the
> two components of /dev/md/boot (randomly, it seems).
> Later, when /dev/md/boot is assembled, one drive is "busy",
> because it belongs to /dev/md_d127, and the array is put
> together degraded, i.e. with the other disk only.

Just a "me too". I also started seeing this after upgrading to fedora
10. I had to create a startup script to stop md_d0 and reassemble
everything else.

