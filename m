From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 12:13:50 -0500
Message-ID: <200501101713.j0AHDx922062@www.watkins-home.com>
References: <200501101734.24851.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101734.24851.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In my log files, which go back to Dec 12

I have 4 of these:
raid5: switching cache buffer size, 4096 --> 1024

And 2 of these:
raid5: switching cache buffer size, 1024 --> 4096

So, it would concern me!  The message is from RAID5, not LVM.  I base this
on "raid5:" in the log entry.  :)

Guy

I found this from Neil:
"You will probably also see a message in the kernel logs like:
             raid5: switching cache buffer size, 4096 --> 1024

The raid5 stripe cache must match the request size used by any client.
It is PAGE_SIZE at start up, but changes whenever is sees a request of a
difference size.
Reading from /dev/mdX uses a request size of 1K.
Most filesystems use a request size of 4k.

So, when you do the 'dd', the cache size changes and you get a small
performance drop because of this.
If you make a filesystem on the array and then mount it, it will probably
switch back to 4k requests and resync should speed up.

NeilBrown"

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten
Sent: Monday, January 10, 2005 11:34 AM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

On Saturday 08 January 2005 20:01, maarten wrote:
> On Saturday 08 January 2005 17:49, maarten wrote:
> > On Saturday 08 January 2005 15:52, Frank van Maarseveen wrote:
> > > On Fri, Jan 07, 2005 at 04:57:35PM -0500, Guy wrote:

> As the system is now online again, busy copying, I can show the exact
> config:
>

Well all about the array is done and working fine up to now.  Except one
thing 
that I didn't anticipate: The application that's supposed to run has some 
problems under -I suppose- the new 2.4.28 kernel. I've had two panics / 
oopses in syslog already, and the process then is unkillable, so a reboot is

in order.   But I think that's bttv related, not the I/O layer.
In any case I suffered through two lengthy raid resyncs already... ;-|

So I've been shopping around for a *big* servercase today so I can put all 
disks (these 5, plus 6 from the current fileserver) in one big tower. I'll 
then use that over NFS and can revert back to my older working kernel.

I've chosen a Chieftec case, as can be seen here 
http://www.chieftec.com/products/Workcolor/CA-01.htm
and here in detail
http://www.chieftec.com/products/Workcolor/NewBA.htm
Nice drive cages, eh ? :-)

P.S.:  I get this filling up my logs. Should I be worried about that ?
Jan 10 11:30:32 dozer kernel: raid5: switching cache buffer size, 512 -->
4096
Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 4096 -->
512
Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 512 -->
4096
Jan 10 11:30:36 dozer kernel: raid5: switching cache buffer size, 4096 -->
512

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

