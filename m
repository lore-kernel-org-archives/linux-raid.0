From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: Raid1 element stuck in (S) state
Date: Mon, 27 Oct 2014 16:57:16 -0400
Message-ID: <20141027165716.44eaab04@jlaw-desktop.mno.stratus.com>
References: <87k33lwq7s.fsf@muck.riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k33lwq7s.fsf@muck.riseup.net>
Sender: linux-raid-owner@vger.kernel.org
To: micah anderson <micah@debian.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Oct 2014 10:18:47 -0400
micah anderson <micah@debian.org> wrote:

> 
> Hi,
> 
> i've got a raid1 setup, where one drive died, it was replaced with a new
> one, but its stuck in a (S) state and I can't seem to get it added into
> the array, /proc/mdstat looks like this:
> 
> md3 : active raid1 sdc1[2](S) sdd1[1]
>       976759672 blocks super 1.2 [2/1] [_U]
> 
> where sdc1 is the replaced drive.

Hi Micah,

What does the output from mdadm --detail /dev/md3 look like?

-- Joe
