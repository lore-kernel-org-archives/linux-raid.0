From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: non-persistent superblocks?
Date: Thu, 30 Jan 2014 10:16:24 +0000
Message-ID: <BLU0-SMTP148F6E0422558E051D1067198AF0@phx.gbl>
References: <52E9D9CC.9000908@cas.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E9D9CC.9000908@cas.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Schanzle <mdadm@cas.homelinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2014-01-29 at 23:49 -0500, Chris Schanzle wrote:

<snip, as my reply might be relevent, or not>

Two things come to mind, the first is if you updated the mdadm.conf
(/etc/mdadm/mdadm.conf or /etc/mdadm.conf)

The second is, update-initramfs -u to make sure things are setup for the
boot process. (I tend to do this when ever i change something that
"might" change a boot process... even if it does not, its pure habit as
apposed to correct procedure)




