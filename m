From: Luca Berra <bluca@comedia.it>
Subject: Re: how to which to bigger disk (md can do it?)
Date: Mon, 17 Nov 2003 10:29:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031117092922.GD30745@percy.comedia.it>
References: <3FB75992.3020608@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FB75992.3020608@bnap.hu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 16, 2003 at 12:03:46PM +0100, Farkas Levente wrote:
>hi,
>- put the 8 disk to another server and run rsync through two gigabit 
>ethernet card. but it can takes more than a day to sync about 800GB.
well rsync is incremental, you could do an initial rsync during the
working week and do another to upgrade deltas during the weekend.

>- switch the disks one-by-one in the current server and leave linux's 
>software raid to sync the data. in this case we only have to stop the 
in this case you will have disks used up to 120Gb and an 80 gb of unused
space at the end. you could create another raid5 there, but it does not
seem appealing to me.

Really weird idea: please do not do it on real data.
You will probably shoot yourself doing this
- Switch the disks one by one.
- When you are over create a new raid5 over the existing one (keeping the
same settings for stripe size and parity algo)
- Resize the filesystem.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
