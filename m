From: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Subject: reproducible kernel Oops in mdrecoveryd (triggered by md raid1 re-syncs)
Date: Tue, 28 Jan 2003 02:24:44 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1160000.1043738684@shieldbreaker.l33tskillz.org>
References: <Pine.LNX.4.44.0301241529360.26021-100000@pcmy.sei.cmu.edu> <15922.5878.154835.39402@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15922.5878.154835.39402@notabene.cse.unsw.edu.au>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-01-25 at 15:47:50+1100 Neil Brown <neilb@cse.unsw.edu.au> wrote:

> Very odd.  What you do should have the desired result, but obviously
> doesn't.

Thanks for your response.

Alas, the problem isn't with mdadm.  :(  This is the problem:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=82815

(I wasn't noticing the Oops in the voluminous output from the md
driver.)

> You didn't say which kernel you are running - 2.4 or 2.5.xx

Red Hat's latest errata kernel for 8.0 (2.4.18-19.8.0).

> I assume there aren't any other RAID arrays present.  Is this
> correct (or did you edit the output of /proc/mdstat).

Nope, no other arrays.

I was looking at the notes for 2.4.21-pre3, and I see there are a
couple of md fixes from you in there.  Unless you have a better idea,
I'll try backporting drivers/md/md.c from 2.4.21-pre3 to Red Hat's
2.4.18-19.8.0 and give that whirl...

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA

