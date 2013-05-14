From: Dusty Mabe <dustymabe@gmail.com>
Subject: Re: 0.90 vs 1.X - Differing behavior for device # during
 fail/remove/add operation
Date: Tue, 14 May 2013 16:31:44 -0400
Message-ID: <CAFfJ-R4WAk0rExAJxhE374-ePpDVnP2oQ8C_g+XC32yMTD2MWA@mail.gmail.com>
References: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
 <CAFfJ-R6Fgz+Mye2FX5D-+uaM0jgUe2j4nnE1ACyCwwk=9X-KPQ@mail.gmail.com>
 <20130510072906.6d457c29@notabene.brown> <CAFfJ-R5_Hcu37DNvQQw8tDyvJPktg8YAvgs-L+CyrVBB4ZRBcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFfJ-R5_Hcu37DNvQQw8tDyvJPktg8YAvgs-L+CyrVBB4ZRBcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Dusty Mabe <dustymabe@gmail.com>
List-Id: linux-raid.ids

On Fri, May 10, 2013 at 8:04 PM, Dusty Mabe <dustymabe@gmail.com> wrote:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aeceedf..b47fd35 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7023,7 +7023,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
>                 rdev_for_each(rdev, mddev) {
>                         char b[BDEVNAME_SIZE];
>                         seq_printf(seq, " %s[%d]",
> -                               bdevname(rdev->bdev,b), rdev->desc_nr);
> +                               bdevname(rdev->bdev,b), rdev->raid_disk);
>                         if (test_bit(WriteMostly, &rdev->flags))
>                                 seq_printf(seq, "(W)");
>                         if (test_bit(Faulty, &rdev->flags)) {


Hey Neil, Sorry to be a pest. Do you have an opinion on this?
