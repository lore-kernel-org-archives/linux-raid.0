From: Dusty Mabe <dustymabe@gmail.com>
Subject: Re: 0.90 vs 1.X - Differing behavior for device # during
 fail/remove/add operation
Date: Thu, 16 May 2013 00:14:19 -0400
Message-ID: <CAFfJ-R5+O2GttF-E0FBd+QXeQb1EsDuxjz+1w9ZQVzYUAHHfnQ@mail.gmail.com>
References: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
 <CAFfJ-R6Fgz+Mye2FX5D-+uaM0jgUe2j4nnE1ACyCwwk=9X-KPQ@mail.gmail.com>
 <20130510072906.6d457c29@notabene.brown> <CAFfJ-R5_Hcu37DNvQQw8tDyvJPktg8YAvgs-L+CyrVBB4ZRBcw@mail.gmail.com>
 <20130516104139.1a904f3f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130516104139.1a904f3f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, May 15, 2013 at 8:41 PM, NeilBrown <neilb@suse.de> wrote:

> The problem with doing this is that it is potentially an API change.
> It is unlikely but possible that some script depends on the current meaning
> of the number.
>
> Also it would result in spares being reported as e.g.
>      sda1[-1]S
> as 'raid_disk' for a spare is '-1'.
>

Excellent points. Yes it would be a sort of an API change which would
not be good for people who depend on it to act that way. That is sort
of how I ended up "caring so much" about it in the first place. 0.90
metadata behaved one way and now 1.X behaves differently so I need to
update some tools to take that into account. Before I updated the
tools I wanted to make sure it wasn't a "bug" and something that you
wanted to fix. If it was then I would possibly try to pull in the
kernel patch rather than change the tools.

>
> My leaning is to not worry too much about /proc/mdstat, but instead add a
> "--status" option to "mdadm" which prints out a summary similar
> to /proc/mdstat, but more coherent and less full of noise.
>

This looks nice but I wouldn't discount the value of /proc/mdstat. If
monitoring tools check the status of raid often then I would rather
them use file I/O of a file maintained by the kernel rather than
running a command each time and parsing output.

Thanks for collaborating with me on this. I'll update my tools.

Dusty Mabe
