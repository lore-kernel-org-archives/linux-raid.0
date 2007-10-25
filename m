From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Thu, 25 Oct 2007 06:33:52 -0700
Message-ID: <47209B40.1000807@amfes.com>
References: <46D3147D.2040201@amfes.com>	<46D49F1A.7030409@tmr.com>	<46E4A39C.8040509@amfes.com>	<46E4A5F0.9090407@sauce.co.nz>	<46E4A7C3.1040902@amfes.com>	<471F5542.3020504@amfes.com> <18208.13247.106651.142652@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18208.13247.106651.142652@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> It might be worth finding out where mdadm is being run in the init
> scripts and add a "-v" flag, and redirecting stdout/stderr to some log
> file.
> e.g.
>    mdadm -As  -v > /var/log/mdadm-$$ 2>&1
>
> And see if that leaves something useful in the log file.
>
>   
I haven't rebooted yet, but here's my /etc/udev/rules.d/70-mdadm.rules
file (BTW - running on Ubuntu 7.10 Gutsy):

SUBSYSTEM=="block", ACTION=="add|change",
ENV{ID_FS_TYPE}=="linux_raid*", RUN+="watershed -i udev-mdadm
/sbin/mdadm -As -v > /var/log/mdadm-$$ 2>&1"

# This next line (only) is put into the initramfs,
#  where we run a strange script to activate only some of the arrays
#  as configured, instead of mdadm -As:
#initramfs# SUBSYSTEM=="block", ACTION=="add|change",
ENV{ID_FS_TYPE}=="linux_raid*", RUN+="watershed -i udev-mdadm
/scripts/local-top/mdadm from-udev"


Could that initramfs line be causing the problem?
-- 
Daniel
