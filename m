From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Creating RAID1 with "missing"  - mdadm 1.90
Date: Sun, 6 Mar 2005 00:29:19 +0100
Message-ID: <fvrpf2-8kl.ln1@news.it.uc3m.es>
References: <422A2FD1.2010106@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

berk walker <berk@panix.com> wrote:
> What might the proper [or functional] syntax be to do this?
> 
> I'm running 2.6.10-1.766-FC3, and mdadm 1.90.

Substitute the word "missing"  for the corresponding device in the
mdadm create command.

(quotes manual page)

    To create a "degraded" array in which some devices are missing,
    simply give the word "missing" in place of a device name.

Peter

