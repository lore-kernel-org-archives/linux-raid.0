From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid1-diseaster on reboot: old version overwrites new version
Date: Sun, 3 Apr 2005 08:31:13 +1000
Message-ID: <16975.7473.907661.114897@cse.unsw.edu.au>
References: <424EBDB7.2000106@goldfisch.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from peter pilsl on Saturday April 2
Sender: linux-raid-owner@vger.kernel.org
To: peter pilsl <pilsl@goldfisch.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 2, pilsl@goldfisch.at wrote:
> 
> * What did I do wrong?
> 
> The only explantion to me is, that I had the wrong entry in my 
> lilo.conf. I had root=/dev/hda6 there instead of root=/dev/md2
> So maybe root was always mounted as /dev/hda6 and never as /dev/md2, 
> which was started, but never had any data written to it. Is this a 
> possible explanation?

Yep, this completely explains everything.
/ was *not* on /dev/md2, it was on /dev/hda6 which also happened to be
a part of an unused raid1 array.

After a crash, the raid1 array did a resync copying from hdc6 to
hda6.  Very sad.  Very good that you had backups.

2.6 won't let you do this: you cannot have a partition in a raid array
and mounted as a filesystem at the same time.

NeilBrown
