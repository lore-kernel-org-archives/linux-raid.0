From: Luca Berra <bluca@comedia.it>
Subject: Re: md_import_device returned -16 raid1
Date: Mon, 18 Jul 2005 17:57:06 +0200
Message-ID: <20050718155706.GF31959@percy.comedia.it>
References: <Pine.LNX.4.61.0507161534210.8523@hoss.npl.com> <17113.37737.512268.68189@cse.unsw.edu.au> <Pine.LNX.4.61.0507161611050.8523@hoss.npl.com> <Pine.LNX.4.61.0507161630330.8523@hoss.npl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0507161630330.8523@hoss.npl.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 16, 2005 at 04:32:05PM -0700, Jim Radford wrote:
>lvm2 seems to be the cause, I removed all lv/vg/pv's and it started fine. 
>My guess is I need to change something in the mandrake initscripts (order 
>wise) to make sure lvm doesn't kick into gear until the raid has started.
>
check you have 
    md_component_detection = 1

in /etc/lvm/lvm.conf, it should be the default.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
