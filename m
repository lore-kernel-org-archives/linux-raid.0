From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: Reshape stalls and fails when SELinux is enabled
Date: Thu, 10 Dec 2015 11:06:51 -0600
Message-ID: <CACsGCyQX4DKfT-6CYd7pa8P-Rq12HhP2tA79F27rw1PbNHe_QQ@mail.gmail.com>
References: <CAMQd7mbdqsw5BiRSKbgBqwNFrz4V8T-A3hOftWReRk1XgXc=+Q@mail.gmail.com>
	<CAMQd7mYscUDroop=4eLz4UwTEiibbF0OqDN1b28yiqJyfW7gGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMQd7mYscUDroop=4eLz4UwTEiibbF0OqDN1b28yiqJyfW7gGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I ran into this as well.  I unwisely worked around it by placing the
backup file on /tmp.  I don't recommend that choice!  I didn't see
your AVC on your EMail, but I recommend you reach out to the SELinux
folks for labeling help.  I've reach out to them in the past and have
found them very helpful (as are the folks here).  Getting the labeling
corrected will not only help you but everyone else in the long term.

I agree that it would be good for mdadm to handle this kind of failure
in a more productive fashion as well.  But I'm only a lurker here.  I
don't have enough knowledge to suggest what would be better.  One
thing that really helped me debug this was commenting out the lines

#StandardOutput=null
#StandardError=null

in the systemd file /lib/systemd/system/mdadm-grow-continue@.service
-- note you have to run systemctl daemon-reload after changing the
file for the change to be noticed.

Once I did that, the system logs had much more useful information.
I'm not sure where that file is sourced, whether it's from the
linux-raid people or from the distributions or somewhere in between.
Does anyone here know if there's a reason why standard out and
standard error are sent to /dev/null for this service?

              Eddie
