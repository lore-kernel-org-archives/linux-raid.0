From: Luca Berra <bluca@comedia.it>
Subject: Re: checking md device parity (forced resync) - is it necessary?
Date: Tue, 5 Sep 2006 18:59:05 +0200
Message-ID: <20060905165904.GB17634@percy.comedia.it>
References: <44FD3C65.8040000@wpkg.org> <17661.19907.140798.943518@cse.unsw.edu.au> <44FD66C3.6040609@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44FD66C3.6040609@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 05, 2006 at 02:00:03PM +0200, Tomasz Chmielewski wrote:
># by default, run at 01:06 on the first Sunday of each month.
>6 1 1-7 * 7 root [ -x /usr/share/mdadm/checkarray ] && 
>/usr/share/mdadm/checkarray --cron --all --quiet
>
>However, it will run at 01:06, on 1st-7th day of each month, and on 
>Sundays (Debian etch).
hihihi
monthday and weekday are or-ed in crontab 

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
