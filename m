From: Luca Berra <bluca@comedia.it>
Subject: Re: Half of RAID1 array missing on 2.6.7-rc3
Date: Thu, 5 Aug 2004 21:52:29 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040805195229.GD7030@percy.comedia.it>
References: <16658.16220.904470.117836@gargle.gargle.HOWL> <16658.35999.308999.766527@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16658.35999.308999.766527@gargle.gargle.HOWL>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 05, 2004 at 03:38:07PM -0400, John Stoffel wrote:
>Now to figure out how to make device mapper only look at /dev/md*
>devices in the future.

how are you using device mapper?
recent versions of lvm2 ignore md components by default
or you can specify a filter in the configuration file.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
