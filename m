From: danci@agenda.si
Subject: Re: Autodetection howto
Date: Wed, 16 Jun 2004 08:34:43 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406160824390.7934@desktop.agenda.si>
References: <000001c45319$55f03570$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000001c45319$55f03570$7001a8c0@darwin>
To: Tim Harvey <tharvey@alumni.calpoly.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Jun 2004, Tim Harvey wrote:

> Greetings,
> 
> I've got a 4-disk RAID5 array that I'm able to manually assemble and
> mount, however I can't figure out how to get the autodetection to work.
> In reading the Linux Software RAID howto it seems like it should 'just
> work', but I'm running into a snag which doesn't seem to be described in
> the HOWTO/FAQ.

> - How do I get around the 'personality 4 is not loaded'?  Did I need to
> run something after I modified /etc/modules.conf for it to take effect?
> - It would appear that the mounting of filesystems via /etc/fstab occurs
> before md autoscans.  How can I delay the mounting of the filesystem
> that exists on the RAID5 array?


1. You need to set the partition that are in the array to the correct
   partition type - fd.

2. If you have raid compiled as modules, you need a proper initrd which
   will load appropriate modules (raid5) and then re-autodetect the arrays
   (SuSE uses 'raidautorun' for that) - all that before your OS actually
   starts booting.

As far as 'personality 4 is not loaded' - I think you don't need to worry 
about it. It just tells you that it's not loaded...

 D.

