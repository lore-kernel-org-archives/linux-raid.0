From: spam@altium.nl (Dick Streefland)
Subject: Re: RAID1 recovery fails with 2.6 kernel
Date: Mon, 20 Oct 2003 08:43:31 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <297d.3f93a033.85d8f@altium.nl>
References: <7da.3f929f6e.d36f3@altium.nl> <16275.32127.862408.701013@notabene.cse.unsw.edu.au>
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
| Thanks for providing a script...
| It works fine for me (2.6.0-test8).
| 
| I don't suppose there is anything in the kernel logs about write
| errors on loop2 ???

No, there was nothing unusual in the log files. I have no access to
the test machine at the moment, but there is a message when the
recovery starts, and a few seconds later the message "sync done".

| Does it fail consistently for you, or only occasionally?

It fails every time. This test was on an dual PIII 450 system, but it
also fails on a VIA C6 system with the 2.6.0-test5 kernel. Both
kernels are compiled without CONFIG_PREEMPT, because I had other
problems that might be related to this option:

  http://www.spinics.net/lists/raid/msg03507.html

Could this be related to CONFIG_DM_IOCTL_V4? I was not sure about this
option, and have not enabled it. Otherwise, I think it is time to put
in some printk's. Do you have suggestions where to start looking?

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

