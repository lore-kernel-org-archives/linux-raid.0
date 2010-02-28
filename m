From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm PATCH 0/2] *** mdmon fixes ***
Date: Sun, 28 Feb 2010 15:41:23 +0100
Message-ID: <20100228144123.GA24781@maude.comedia.it>
References: <cover.1267282753.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1267282753.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Feb 27, 2010 at 04:05:40PM +0100, Luca Berra wrote:
> These close a couple of issues with mdmon.
> I don't claim to understand all of the code yet, but a cursory look leaves me
> with the feeling that there are multiple ways it could still fail
As foreseen it does actually fail...

someone might remember my flaky dual boot system with imsm array
it crashed again, badly
result
mdmon is still running from ALT_RUN, since / is corrupted and cannot be
mounted read-write
but mdadm command looks for mdmon only in VAR_RUN
so a new bunch of patches is due.
these apply over the two preceding patches

3/9 add missing newline to mdmon usage message
4/9 mdmon: check select a writable pid_dir
5/9 mdmon: mdmon_pid should return pid from either dir
6/9 mdmon: connect_monitor should use socket from either dir
7/9 mdmon: move pid_dir to mdmon.c
8/9 mdmon: rework startup and takeover logic

and after I spent a good deal of time fixing the above I was bitten by
the mdmon socket in /var/run/mdadm at shutdown time again. So i added:

9/9 allow redefinition of VAR_RUN

But I respectfully ask to reconsider the placement of mdmon socket and
keep it somewere under /, allowing people to unmount /var.
I don't get why putting sockets in /dev is considered wrong and we must
run through multiple hoops to put those under /var when we already have
sockets in /dev and no-one ever questioned syslogd for doing so.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
