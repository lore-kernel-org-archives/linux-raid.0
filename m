From: Lars Ellenberg <Lars.Ellenberg@linbit.com>
Subject: Re: [patch] md: pass down BIO_RW_SYNC in raid{1,10}
Date: Tue, 9 Jan 2007 15:08:30 +0100
Message-ID: <20070109140830.GE7566@soda.linbit>
References: <20070108090833.GF8125@soda.linbit> <20070108150242.1b39eda2.akpm@osdl.org> <17826.55504.264610.856196@notabene.brown> <20070109071224.GG11203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070109071224.GG11203@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

/ 2007-01-09 08:12:25 +0100
\ Jens Axboe:
> Ack from me as well, it's really a quite nasty bug from a performance
> POV. Not just for DRDB, but for io schedulers as well.

its DRBD, btw... we still work on the database, too, of course :)

something should be done with the other raid levels as well,
but how to do that was not as obvious to me, unfortunately.

-- 
: Lars Ellenberg                            Tel +43-1-8178292-55 :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
