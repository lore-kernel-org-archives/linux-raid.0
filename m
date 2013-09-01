From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 6/6] mdmon: allow disabling "@dmon" command name at compile
 time
Date: Sun, 01 Sep 2013 19:20:13 +0200
Message-ID: <5223774D.50405@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>	<1376677320-12816-7-git-send-email-mwilck@arcor.de> <20130828151505.222eaa0a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130828151505.222eaa0a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/28/2013 07:15 AM, NeilBrown wrote:

> Can you help me understand?  What is anaconda even looking for mdmon?
> Does it need exactly "mdmon" or would "@mdmon" be OK?

To be precise, it's not anaconda but "loader", the C program that starts
anaconda and cleans up after it. It looks exactly for "mdmon". See
https://git.fedorahosted.org/cgit/anaconda.git/tree/loader/shutdown.c?h=rhel6-branch#n59

> Does "started by systemd" mean that "systemctl start mdmon@mdXXX.service" was
> used to start it?  In that case can't we put something in
> systemd/mdmon@.service to make the right thing happen?

Sorry for having explained unclearly. This is *not* a systemd
environment. There is no regular "init" process running AFAICT, "loader"
takes that role as far as necessary in the installation environment.

> 
> I'm going to hold off on this one for the moment.

If this isn't applied, in the RHEL/CentOS 6 installation environment,
"loader" will kill mdmon, and a subsequent "mdadm --wait-clean" will
hang forever.

Martin

> 
> All others applied.
> 
> Thanks,
> NeilBrown

