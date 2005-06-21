From: Luca Berra <bluca@comedia.it>
Subject: Re: Is my raid-1 array working?
Date: Tue, 21 Jun 2005 18:17:41 +0200
Message-ID: <20050621161741.GE27691@percy.comedia.it>
References: <42B8146D.4030004@dor.state.ma.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42B8146D.4030004@dor.state.ma.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 21, 2005 at 09:21:49AM -0400, Ron Murray wrote:
> > Found duplicate PV xxxxxxxxxxxxxxxx: using /dev/sdc4 not /dev/sdb4

check that you have 
    md_component_detection = 1

in /etc/lvm/lvm.conf

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
