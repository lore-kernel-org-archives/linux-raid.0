From: "David Rientjes" <rientjes@google.com>
Subject: Re: Mounting array was read write for about 3 minutes, then Read-only file system error
Date: Mon, 17 Jul 2006 17:04:24 -0700
Message-ID: <9ec263480607171704s555b4fechb20eb36b1d5a1c23@mail.google.com>
References: <e0904ff40607061932l3b1d7849v43ed568aa4fceea8@mail.gmail.com>
	 <17596.8875.945108.21839@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17596.8875.945108.21839@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/17/06, Neil Brown <neilb@suse.de> wrote:
> On Thursday July 6, bkbonner@gmail.com wrote:
> > I created a raid1 array using /dev/disk/by-id with (2) 250GB USB 2.0
> > Drives.  It was working for about 2 minutes until I tried to copy a
> > directory tree from one drive to the array and then cancelled it
> > midstream.  After cancelling the copy, when I list the contents of the
> > directory it doesn't show anything there.
> >
> > When I try to create a file, I get the following error msg:
> >
> > [root@app1 ~]# cd /mnt/usb250
> > [root@app1 usb250]# ls
> > lost+found
> > [root@app1 usb250]# touch test.txt
> > touch: cannot touch `test.txt': Read-only file system
>
> Sounds like you got some disk errors so the filesystem when readonly.
>
> Is there anything in /var/log/messages about errors at that time?

What's /proc/mount for /dev/disk/by-id when it's rw?  Is it
rw,errors=remount-ro?

David
