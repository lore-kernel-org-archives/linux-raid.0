From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: smartchecks of raid members
Date: Tue, 22 Dec 2009 00:45:07 +0000
Message-ID: <4B301693.3070905@anonymous.org.uk>
References: <1261429250.7944.2249.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1261429250.7944.2249.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/12/2009 21:00, Daniel Reurich wrote:
> Is it safe and can it easily be done to put a raid1 member volume into
> "write mostly && write behind" mode temporarily while doing a SMART full
> disk check on that disk?

A little Googling reveals this slightly old blog post from Neil Brown 
http://neil.brown.name/blog/20050727141521-011 which says:
> If you write "writemostly" to /sys/mdX/md/dev-YYYY/state it will turn on write-mostly for that device. You can turn it off with "-writemostly".
> 
> "Writebehind" is a function of the bitmap. You cannot current change this directly online, but you can remove the current bitmap and add a new one with write-behind enabled. 

Sounds like write-mostly is easy enough to enable on-the-fly while 
write-behind is trickier and risks more - if you need a bitmap, you 
probably don't want to be removing it on a running server. Also, iirc 
there was a buglet which could cause an oops when removing a bitmap due 
to a race condition, though iirc again that's been found and fixed recently.

Resuming what Daniel Reurich wrote:
> I believe this may help with the smart check as it stops the
> interruptions caused by reads from the disk, and the writes will be
> delayed and hopefully committed in larger chunks less often.  I also
> this will allow the server to perform better by not blocking until the
> writes on the disk being checked return.
> 
> Is the only risk the delay between a write being completed as far as the
> process is concerned and the write being committed to the disk being
> smart checked?

Well, yes, but that risk is reducing your redundancy while you thrash 
one of your disks. I think if I were you I might try only enabling 
write-mostly to see if that got the S.M.A.R.T. disc check done quickly 
enough while the server was quietish, and perhaps only checking one disc 
per quiet period.

Cheers,

John.

