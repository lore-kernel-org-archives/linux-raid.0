From: Luca Berra <bluca@comedia.it>
Subject: Re: Half of RAID1 array missing on 2.6.7-rc3
Date: Thu, 5 Aug 2004 22:34:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040805203425.GE7030@percy.comedia.it>
References: <16658.16220.904470.117836@gargle.gargle.HOWL> <16658.35999.308999.766527@gargle.gargle.HOWL> <20040805195229.GD7030@percy.comedia.it> <16658.37628.400095.731330@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16658.37628.400095.731330@gargle.gargle.HOWL>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 05, 2004 at 04:05:16PM -0400, John Stoffel wrote:
>Luca> recent versions of lvm2 ignore md components by default or you
>Luca> can specify a filter in the configuration file.
>
>Which file is that?  There's nothing in /etc/dm/... that I can see.
>There's some stuff in /etc/lvm/lvm.conf, but I haven't touched that at
>all.

/etc/lvm/lvm.conf

if you have a recent version you will find a 
md_component_detection = 1
line,
if not you can change the
filter = [ "a/.*/" ]
to
filter = [ "a|/dev/md*|" ]


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
