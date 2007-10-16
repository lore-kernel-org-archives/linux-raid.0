From: "Mike Snitzer" <snitzer@gmail.com>
Subject: kicking non-fresh member from array?
Date: Tue, 16 Oct 2007 14:20:13 -0400
Message-ID: <170fa0d20710161120u65d5fd1bifea2aef4176c93f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All,

I have repeatedly seen that when a 2 member raid1 becomes degraded,
and IO continues to the lone good member, that if the array is then
stopped and reassembled you get:

md: bind<nbd0>
md: bind<sdc>
md: kicking non-fresh nbd0 from array!
md: unbind<nbd0>
md: export_rdev(nbd0)
raid1: raid set md0 active with 1 out of 2 mirrors

I'm not seeing how one can avoid assembling such an array in 2 passes:
1) assemble array with both members
2) if a member was deemed "non-fresh" re-add that member; whereby
triggering recovery.

So why does MD kick non-fresh members out on assemble when its
perfectly capable of recovering the "non-fresh" member?  Looking at
md.c it is fairly clear there isn't a way to avoid this 2-step
procedure.

Why/how does MD benefit from this "kicking non-fresh" semantic?
Should MD/mdadm be made optionally tolerant of such non-fresh members
during assembly?

Mike
