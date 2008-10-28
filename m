From: Luca Berra <bluca@comedia.it>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 07:32:47 +0100
Message-ID: <20081028063247.GC7764@percy.comedia.it>
References: <18692.62860.863118.727187@notabene.brown> <20081027082257.GB1801@piper.oerlikon.madduck.net> <1225120416.4845.128.camel@firewall.xsintricity.com> <20081027161000.GG17300@skl-net.de> <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com> <1225128270.4845.144.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1225128270.4845.144.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 01:24:30PM -0400, Doug Ledford wrote:
>that are also listed in the mdadm.conf file.  This makes sure that known
>arrays are assembled and started if at all possible, but we only start
>unknown arrays if they are complete.

seems interesting, do you also have any provisioning for avoiding it to
start unknown arrays at all, if i don't want it to?

i.e. it is on shared storage and in this moment another node has it running.

L.



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
