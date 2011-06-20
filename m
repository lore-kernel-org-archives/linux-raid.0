From: Phil Turmel <philip@turmel.org>
Subject: Re: flummoxed why I can't umount my md device.  fuser and lsof show
 no files locked
Date: Mon, 20 Jun 2011 15:06:35 -0400
Message-ID: <4DFF9A3B.5040605@turmel.org>
References: <4DFF87F8.8050202@gmail.com> <20110621000317.156d7d27@natsu> <4DFF8E6C.8080100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DFF8E6C.8080100@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Simon,

On 06/20/2011 02:16 PM, Simon McNair wrote:
> Hi Roman,
> Sorry for the stupid omission, I did try running umount /media/local/Raid to no avail.  The other thing I also tried was the lazy dismount option, but it never unmounted, I did a force, then remount and dismount, but it didn't make any difference to the errors.  none of the processes have a working directory in the Raid folder as it is just for storage, the OS and apps are on a separate drive entirely.  I also ensured that my ssh session was not in the /media/local folder either.
> 
> I am pretty sure that I actually want the array running in order to run a mkfs against it (obviously) I just tried that as a last ditch attempt.  I'm really just trying to figure out how I can find out what process has the folder locked if lsof and fuser can't tell me :-)

You have to consider that the kernel itself may be holding it open.  The most common cause in my experience is a loop mounted file, or stacked userspace filesystem.  What does lsdrv[1] say?  If a loop device is active, run "losetup -a".

Phil

[1] http://github.com/pturmel/lsdrv
