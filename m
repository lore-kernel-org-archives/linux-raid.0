From: Luca Berra <bluca@comedia.it>
Subject: Re: Software RAID 0+1 with mdadm.
Date: Wed, 26 Jan 2005 16:17:03 +0100
Message-ID: <20050126151703.GA2040@percy.comedia.it>
References: <1106692101.15355.16.camel@serpent>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1106692101.15355.16.camel@serpent>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 25, 2005 at 02:28:21PM -0800, Brad Dameron wrote:
>Everything seems ok after boot. But again no /dev/md0 in /proc/mdstat.
>But then if I do a mdadm --assemble --scan it will then load /dev/md0. 
there is a bug in mdadm, see my mail "patches for mdadm 1.8.0" or wait
for 1.9.0

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
