From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid1 auto-detection...
Date: Thu, 26 Aug 2004 09:07:32 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040826070732.GD23469@percy.comedia.it>
References: <1093473322.2398.12.camel@south.rosestar.lan> <1093493854.2398.22.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1093493854.2398.22.camel@south.rosestar.lan>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 25, 2004 at 11:17:34PM -0500, Bob Hillegas wrote:
>I know it's bad form to reply to your own message, but I just resolved
>my problem.
>
>The Fedora Core 2 kernel isn't the source of the problem. It's the
>rc.sysinit script. It expects to use raidstart and so checks for the
>presence of the /etc/raidtab file. Since I don't have one, no attempt
>was made to start the raid.
>
>I'll hammer together changes to allow mdadm --assemble --scan to start
>the raid and then post when it works.
>
check the archives, someone already did.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
