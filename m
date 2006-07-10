From: Karl Voit <news@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 19:26:58 +0000 (UTC)
Message-ID: <loom.20060710T211030-179@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org>  <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>  <loom.20060710T095111-275@post.gmane.org>  <44B213CD.5010907@idgmail.se>  <loom.20060710T112944-980@post.gmane.org>  <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>  <loom.20060710T132722-427@post.gmane.org>  <62b0912f0607100507s21544d12xec9a8bf117b6edc2@mail.gmail.com>  <loom.20060710T142912-798@post.gmane.org> <62b0912f0607101006k6f9e66cfp86d4f0d0c1de4a3a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich <at> gmail.com> writes:

> Karl Voit wrote:
> > Before that, I'd like to check again now with
> > the latest kernel and the latest mdadm:
> >
> > # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> > mdadm: No suitable drives found for /dev/md0
> > [ ... snip: same message with --run and --force ... ]
> 
> No idea what that means, sorry.
> Check the MDADM source code, as far as I remember it's well commented.

;-)
Unfortunately I am mainly a user and not a good C programmer :-(

if (super == NULL) {
  fprintf(stderr, Name ": No suitable drives found for %s\n", mddev);
[...]

Well I guess, the message will be shown, if the superblock is not found.

> > root <at> ned ~ # mdadm --zero-superblock /dev/sda
> > mdadm: Unrecognised md component device - /dev/sda
> 
> Ack?
> No clue, sorry.  Perhaps you've already zeroed that superblock?

Pretty sure, that this happened during my tests, yes.

> Check the source for the meaning of the message.

st = guess_super(fd);
  if (st == NULL) {
    if (!quiet)
      fprintf(stderr, Name ": Unrecognised md component device - %s\n", dev);
[...]

Again: this seems to be the case, when the superblock is empty.

> Or try to get hold of our local target of godly worship, NeilB .

OK, then how can a dumb user, who deleted his own raid-superblocks, attract
local gods to help out with surprising sd[abcd]-reassembling-magic? ;-)

> > OK, those are other (newer) messages. Do they change anything or
> > should I try the commands above now?
> 
> Depends how careful you are.

Since my miserably failure I am probably too careful *g*

The problem is also, that without deeper background knowledge, I can not
predict, if this or that permanently affects the real data on the disks.

Maybe such a person like me starts to think that sw-raid-tools like
mdadm should warn users before permanent changes are executed. If
mdadm should be used by users (additional to raid-geeks like you),
it might be a good idea to prevent data loss. (Ment as a suggestion.) 

> Personally, I'd probably try and find out why the above commands fail,
> just in case there's something wrong with your new kernel or mdadm.

OK. I'll try my best.


