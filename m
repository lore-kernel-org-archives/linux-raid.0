From: Luca Berra <bluca@comedia.it>
Subject: Re: Bad Recovery
Date: Sat, 10 Jan 2004 13:45:13 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040110124512.GB5928@percy.comedia.it>
References: <4648.192.168.1.81.1073694507.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4648.192.168.1.81.1073694507.squirrel@exitwound.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 09, 2004 at 06:28:27PM -0600, Stephen Hargrove wrote:
># mdadm -a /dev/hde1
>mdadm: /dev/hde1 does not appear to be an md device

syntax is: mdadm /dev/md<number> -a /dev/hde1

># mount /stuff
>mount: wront fs type, bad option, bad superblock on /dev/md0,
>    or too many mounted file systems
>
>I'm sure I've left out a ton of information you might need.  If you'll let
>me know what's needed, I'll be glad to forward it.
/proc/mdstat,
output of mdadm --assemble ... when you started the md0
syslog

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
