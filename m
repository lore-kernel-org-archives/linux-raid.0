From: Luca Berra <bluca@comedia.it>
Subject: Re: multipath md devices
Date: Thu, 23 Sep 2004 07:46:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040923054607.GB27855@percy.comedia.it>
References: <4151E37B.8040207@bms.com> <1095888922.4196.1548.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1095888922.4196.1548.camel@compaq.xsintricity.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 22, 2004 at 05:35:23PM -0400, Doug Ledford wrote:
>Yeah, IBM wrote a little app to help with that.  We stuffed it into the
>mdadm package we ship since that seemed the most appropriate place for
>it.  It's called mdmpd and that's it's job basically.  Very simple app,
>but doesn't run on upstream kernels at the moment (it wants the md event
>interface which hasn't yet been submitted upstream by Neil).

iirc the it has been submitted and refused
http://marc.theaimsgroup.com/?t=109417961300007&r=1&w=2&n=8

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
