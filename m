From: Dusty Mabe <dustymabe@gmail.com>
Subject: Re: 0.90 vs 1.X - Differing behavior for device # during
 fail/remove/add operation
Date: Fri, 10 May 2013 20:04:27 -0400
Message-ID: <CAFfJ-R5_Hcu37DNvQQw8tDyvJPktg8YAvgs-L+CyrVBB4ZRBcw@mail.gmail.com>
References: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
 <CAFfJ-R6Fgz+Mye2FX5D-+uaM0jgUe2j4nnE1ACyCwwk=9X-KPQ@mail.gmail.com> <20130510072906.6d457c29@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130510072906.6d457c29@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Dusty Mabe <dustymabe@gmail.com>
List-Id: linux-raid.ids

On Thu, May 9, 2013 at 5:29 PM, NeilBrown <neilb@suse.de> wrote:
>
> It is an unfortunate consequence of incoherent design.
> I've occasionally wondered if I should "fix" it.

Neil,

Thanks for the insight. I don't know the code well but I do notice
that changing the md_seq_show() function to print out the raid_disk
rather than desc_nr at least gives me the "desired" behavior from
/proc/mdstat. This still doesn't change the fact that the "Number" is
still changed in the mdadm --detail output but is a quick easy way to
change mdstat without actually having to re-architect anything.

What do you think?

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aeceedf..b47fd35 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7023,7 +7023,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
                rdev_for_each(rdev, mddev) {
                        char b[BDEVNAME_SIZE];
                        seq_printf(seq, " %s[%d]",
-                               bdevname(rdev->bdev,b), rdev->desc_nr);
+                               bdevname(rdev->bdev,b), rdev->raid_disk);
                        if (test_bit(WriteMostly, &rdev->flags))
                                seq_printf(seq, "(W)");
                        if (test_bit(Faulty, &rdev->flags)) {
