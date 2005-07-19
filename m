From: Luca Berra <bluca@comedia.it>
Subject: Re: md_import_device returned -16 raid1
Date: Tue, 19 Jul 2005 13:05:28 +0200
Message-ID: <20050719110527.GF14628@percy.comedia.it>
References: <Pine.LNX.4.61.0507161534210.8523@hoss.npl.com> <17113.37737.512268.68189@cse.unsw.edu.au> <Pine.LNX.4.61.0507161611050.8523@hoss.npl.com> <Pine.LNX.4.61.0507161630330.8523@hoss.npl.com> <20050718155706.GF31959@percy.comedia.it> <Pine.LNX.4.61.0507181510580.8523@hoss.npl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0507181510580.8523@hoss.npl.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 18, 2005 at 03:12:07PM -0700, Jim Radford wrote:
>On Mon, 18 Jul 2005, Luca Berra wrote:
>
>>On Sat, Jul 16, 2005 at 04:32:05PM -0700, Jim Radford wrote:
>>>lvm2 seems to be the cause, I removed all lv/vg/pv's and it started fine. 
>>>My guess is I need to change something in the mandrake initscripts (order 
>>>wise) to make sure lvm doesn't kick into gear until the raid has started.
>>>
>>check you have 
>>md_component_detection = 1
>>
>>in /etc/lvm/lvm.conf, it should be the default.
>
>That is the default, however the way Mandrake does their initscript I had 
>to move the LVM stuff until after the raid is started to make it work 
>right. It is working great now.

it should not be needed at all. lvms that are part of raids should be
ignored by the first lvm run due to md_component_detection = 1, if this
does not apply to you would you care open a bug at qa.mandriva.com
against LVM, i'll look into it..

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
