From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Performance question
Date: Wed, 21 Jan 2009 21:26:49 +0100
Message-ID: <20090121202649.GA27298@lazy.lzy>
References: <20090117171806.GA9432@lazy.lzy> <20090117220849.GB29866@rap.rap.dk> <20090119181253.GA4290@lazy.lzy> <20090121001503.GA26587@rap.rap.dk> <20090121191452.GA4752@lazy.lzy> <20090121201541.GA20499@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090121201541.GA20499@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

thanks for the explanation about metadata.

> mdasseble is specifically made for initrd, so why not use it here?

I do not know, I just noticed that, on Fedora,
the initrd with RAID has /etc/mdadm.conf and it
calls "mdadm -As ...".
Which I found annoying, since I do not know
what will happen in case an array is changed
(UUID change, /etc/mdadm.conf not more consistent).

Anyway, if you say "mdassemble" is OK, no problem.

Thanks,

bye,

-- 

piergiorgio
