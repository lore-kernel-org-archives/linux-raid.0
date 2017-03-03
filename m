From: Michael Shigorin <mike@altlinux.org>
Subject: Re: [mdadm] compiler warning
Date: Fri, 3 Mar 2017 11:14:36 +0300
Message-ID: <20170303081436.GN21109@imap.altlinux.org>
References: <20170222160941.GV7920@imap.altlinux.org>
 <87bmtjnt5v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bmtjnt5v.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 03, 2017 at 10:41:16AM +1100, NeilBrown wrote:
> > Thought I'd better write this. :)
> Thanks for the report, though we prefer such things to be sent to
>   linux-raid@vger.kernel.org

Ack!

> The warning is just telling us that the compiler is smart
> enough to deduce that whenever st is uninitialised, err = 0.
> So the code is safe, but maybe more complex than needed.
> I'll submit a patch to improve it a little.

Thanks for explanation, I'll file a bug against the compiler then.
Your commit has cleared the warning in the mean time.

-- 
š---- WBR, Michael Shigorin / http://altlinux.org
šš------ http://opennet.ru / http://anna-news.info
