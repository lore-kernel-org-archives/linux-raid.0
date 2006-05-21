From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: bitmap size
Date: Mon, 22 May 2006 09:27:17 +1000
Message-ID: <17520.63317.693491.212555@cse.unsw.edu.au>
References: <446D0119.1010508@phx6a.ath.cx>
	<17517.2191.803890.424144@cse.unsw.edu.au>
	<91ebddcf0605211608i1145d957g65b18b3caa68cfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stefano Russo on Monday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Stefano Russo <stefano.russo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


(Please don't reply off-list.  If the conversation starts on the list,
please leave it there unless there is a VERY GOOD reason).

On Monday May 22, stefano.russo@gmail.com wrote:
> On 5/19/06, Neil Brown <neilb@suse.de> wrote:
> >
> > On Friday May 19, ste@phx6a.ath.cx wrote:
> > > As i can see the bitmap do exactly this, but the default bitmap is too
> > > small!
> >
> > Why do you say that?
> > Are you using an internal bitmap, or a bitmap in a separate file?
> 
> 
> I was using bitmap in a separate file.
> Why i said that tha bitmap is too small? I try to explain:
> 
> the raid device is a raid1, created on /dev/md0 trought mdadm, and the
> bitmap use a 4 kb chunk-size on external file (in root directory)
> 
> 
> setfaulty /dev/md0 /dev/nda
> raidhotremove /dev/md0 /dev/nda
> cd /mnt/md0
> wget http://...   (240 kb file...)
> raidhotadd /dev/md0 /dev/nda
> 
> And now dmesg said that the bitmap was obsolete (0<1 or something like that)
> and that the md driver will force a total recovery.

raidhotadd doesn't know anything about bitmaps.
If you use 'mdadm /dev/mda --add /dev/nda' you should find that it
works better.

I recommend getting rid of setfaulty / raidhotadd /raidhotremove etc
and just using mdadm.

NeilBrown


> 
> A recovery of 40 gb for a 240 kb file is a little bit expensive.. :-)
> 
> Unfortunately i cannot give you the exact output because the server is down
> now.:-|
> 
> 
> The only way to control the size of the bitmap is the change the
> > bitmap chunk size.
> 
> 
> Okay thanks.
> 
> Warning: if you have more than 1 million bits in the bitmap, the
> > kernel may fail in memory allocation and may not be able to assemble
> > your array.
> 
> 
> Thankyou for your help.
> 
> Stefano.
