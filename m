From: "Marc Marais" <marcm@liquid-nexus.net>
Subject: Re: mdadm --grow failed
Date: Sun, 18 Feb 2007 17:20:47 +0800
Message-ID: <20070218091504.M97223@liquid-nexus.net>
References: <20070217030514.M74974@liquid-nexus.net> <17878.49009.771973.884472@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17878.49009.771973.884472@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, I understand the risks which is why I did a full backup before doing 
this. I have subsequently recreated the array and restored my data from 
backup.

Just for information, the e2fsck -n on the drive hung (unresponsive with no 
I/O) so I assume the filesystem was hosed. I suspect resyncing the array 
after the grow failed was a bad idea. 

I'm not sure how the grow operation is performed but to me it seems that 
their is no fault tolerance during the operation so any failure will cause a 
corrupt array. My 2c would be that if any drive fails during a grow 
operation that the operation is aborted in such a way as to allow a restart 
later (if possible) - as in my case a retry would've probably worked. 

Anyway, if you need more info to help improve growing arrays let me know.

As a side note, either my hardware (Promise TX4000) card is acting up or 
there are still some unresolved issues with libata in general and/or 
sata_promise itself. 

Regards,
Marc

On Sat, 17 Feb 2007 19:40:17 +1100, Neil Brown wrote
> On Saturday February 17, marcm@liquid-nexus.net wrote:
> > 
> > Is my array destroyed? Seeing as the sda disk wasn't completely synced 
I'm 
> > wonder how it was using to resync the array when sdc went offline. I've 
got 
> > a bad feeling about this :|
> 
> I can understand your bad feeling...
> What happened there shouldn't happen, but obviously it did.  There is
> evidence that all is not lost but obviously I cannot be sure yet.
> 
> Can you "fsck -n" the array?  does the data still seem to be intact?
> 
> Can you report exactly what version of Linux kernel, and of mdadm you
> are using, and give the output of "mdadm -E" on each drive.
> 
> I'll try to work out what happened and how to go forward, but am
> unlikely to get back to you for 24-48 hours (I have a busy weekend:-).
> 
> NeilBrown


--
