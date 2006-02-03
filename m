From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: raid 4, and bitmap.
Date: Fri, 3 Feb 2006 01:15:52 +0100
Message-ID: <04cc01c62856$ff18c630$9d00a8c0@dcccs>
References: <04c201c62855$5efda450$9d00a8c0@dcccs> <17378.40767.339455.85486@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Friday, February 03, 2006 1:09 AM
Subject: Re: raid 4, and bitmap.


> On Friday February 3, djani22@dynamicweb.hu wrote:
> > Hello, list, Neil,
> >
> > I try to add bitmaps to raid4, and mdadm is done this fine.
> > In the /proc/mdstat shows this, and it is really works well.
> >
> > But on reboot, the kernel drops the bitmap(, and resync the entire array
if
> > it is unclean). :(
> >
> > It is still uncomplete now? (2.6.16-rc1)
>
>
> It is an 'internal' bitmap, or is the bitmap in a file?

It is internal.
The external bitmap is not works for me, because on the boot, only the NFS
is reachable, and it cause crash.

(note: this is raid4 not raid5!)

>
> If the bitmap is in a file, you need to me sure that the file is
> provided by mdadm when the array is assembled - using in-kernel
> autodetect won't work.
>
> If it is an internal bitmap.... it should work.
> Are there any kernel messages during boot that might be interesting?

It is something, i will find it one minute! :-)

>
> NeilBrown

