From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Reshape stalls and fails when SELinux is enabled
Date: Thu, 10 Dec 2015 18:24:12 +0000
Message-ID: <5669C34C.9060606@youngman.org.uk>
References: <CAMQd7mbdqsw5BiRSKbgBqwNFrz4V8T-A3hOftWReRk1XgXc=+Q@mail.gmail.com>
 <CAMQd7mYscUDroop=4eLz4UwTEiibbF0OqDN1b28yiqJyfW7gGw@mail.gmail.com>
 <CACsGCyQX4DKfT-6CYd7pa8P-Rq12HhP2tA79F27rw1PbNHe_QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyQX4DKfT-6CYd7pa8P-Rq12HhP2tA79F27rw1PbNHe_QQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>, Enrico Tagliavini <enrico.tagliavini@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/12/15 17:06, Edward Kuns wrote:
> I ran into this as well.  I unwisely worked around it by placing the
> backup file on /tmp.  I don't recommend that choice! 

Most people don't realise there are various tmp directories, with
different behaviours. /tmp is defined by LSB or somesuch to be real
temporary storage - no guarantees - stuff may disappear at any time.
Which is why my /tmp is a tmpfs - stored in ram. So yes, a backup file
on /tmp is not a good idea ...

/var/tmp is defined as holding data that must survive a reboot - where
emacs and vi and that lot are recommended to store their crash dumps,
recovery files, etc for example.

 I didn't see
> your AVC on your EMail, but I recommend you reach out to the SELinux
> folks for labeling help.  I've reach out to them in the past and have
> found them very helpful (as are the folks here).  Getting the labeling
> corrected will not only help you but everyone else in the long term.
> 
> I agree that it would be good for mdadm to handle this kind of failure
> in a more productive fashion as well.  But I'm only a lurker here.  I
> don't have enough knowledge to suggest what would be better.  One
> thing that really helped me debug this was commenting out the lines
> 
> #StandardOutput=null
> #StandardError=null
> 
> in the systemd file /lib/systemd/system/mdadm-grow-continue@.service
> -- note you have to run systemctl daemon-reload after changing the
> file for the change to be noticed.
> 
> Once I did that, the system logs had much more useful information.
> I'm not sure where that file is sourced, whether it's from the
> linux-raid people or from the distributions or somewhere in between.
> Does anyone here know if there's a reason why standard out and
> standard error are sent to /dev/null for this service?
> 
I wouldn't know for certain, but given the amount of junk so many
programs spew to stdout or stderr (which nobody ever sees because
they're running in a gui), I expect it's because that's what happens by
default anyway :-) They don't want to clutter the logs with all that
junk and chatter.

I often somehow get stdout and stderr for various programs redirected to
konsole, because I'll use dbus-launch to start a program. And then when
the program has exited I'll get loads of rubbish from other programs ...
the chatter is horrendous.

Cheers,
Wol

