From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: [PATCH][RFC] Fix "two RAID1 mirrors are faster than
  three"
Date: Tue, 13 May 2003 17:22:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305131725_MC3-1-38BB-FB28@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

> Either split it into logic bits, or explain in detail what it is
> trying to achieve, or both, and I will tell you what I think.

  It kind of grew into a monster... and there are three FIXMEs that
need looking at in there, too.  I can break this up if you tell
me what to put in each change but it will be slow going.  If
there's no hurry I'd rather do it since it could be useful
experience.

  1.  Change head_position to unsigned long.

    Almost certainly a bug in 2.4 since this is really
    a sector number.

  2.  Add a HEAD_DISTANCE macro to compute distance
      a given mirror's head is from a sector.

    abs(a - b) does not work for unsigned.  Is there a
    better way to do this than what I did?

  3.  Add READABLE_MIRROR macro and use it consistently
      (also inside ITER_THIS/NEXT_READABLE) when looking
      for readable disks.

    This one I'm not really sure of.  read_balance()
    was sometimes checking just (operational) and sometimes
    checking (operational && !write_only)  Other places
    were the same way.

  4.  Add ITERATE_MIRROR, ITER_NEXT_READABLE and
      ITER_THIS_READABLE macros

    ITERATE is pretty straghtforward
    NEXT tries to find the next readable mirror
    THIS only iterates if the current one is unreadable

    THIS/NEXT have safety checks to prevent looping forever
    and the caller must check after using them to see
    if the current disk really is readable/changed.

  5.  Remove per-disk sector limits used for the disk
      switching logic and move them to a global sysctl.
      Add a max_seq_work_per_disk sysctl as well.

    I could see no way of changing max_work_per_disk and
    I needed an easy way to test values.  This should be
    an ioctl but at least this way it can be changed.

  6.  Attempt to balance single sequential streams across
      multiple disks.  This only kicks in when one disk
      has read max_seq_work_per_disk sectors in a row.

    This works wonders on 2.4.20aa1 but makes almost no
    difference on stock kernels AFAICT. (why?)

  7.  Change the basic algorithm in read_balance() so it
      always looks for the nearest disk before deciding
      whether to force a switch.

    If search will cause a disk switch then there is no
    need to force one.

  8.  Some 80-column formatting fixes (probably should go.)

  9.  An unnecessary change to raid1d (should be removed.)

 10.  Change "if (x) BUG()" to "BUG_ON(x)" everywhere.

    This is the proper way since it adds unlikely() to
    the condition.

 11.  Renamed sect_count to same_count and made it unsigned.

    Only read_balance uses this.  I hated the old name, and
    making it unsigned prevents overflow into negative numbers.

 12.  Add an rb_out_nocount label and jump to that on
      exiting when balance cannot be done.

    No sense in counting consecutive reads when balancing
    is impossible anyway...


(I trimmed l-k from the addressees; please copy me on any
replies to linux-raid since I'm not subscribed.)


