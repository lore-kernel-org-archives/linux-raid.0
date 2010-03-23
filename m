From: Drew <drew.kay@gmail.com>
Subject: Re: Controlled shut-down of mdadm
Date: Tue, 23 Mar 2010 10:28:31 -0700
Message-ID: <c268e4661003231028v5562e31etf967a87cbd6c4f74@mail.gmail.com>
References: <4BA8EDC0.4060506@gemmill.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA8EDC0.4060506@gemmill.name>
Sender: linux-raid-owner@vger.kernel.org
To: Graeme Gemmill <graeme@gemmill.name>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On the (hopefully) rare occasions when my RAID server gets shut down, is it
> necessary or desirable to execute a mdadm --stop command in a shut-down
> script? Applications on other PCs may have files open, and if a prolonged
> mains break triggers a UPS shutdown, then there may be data loss (not that
> I'm running a reactor or a bank!).

Assuming by "other PCs" you mean you're sharing files to other
machines using CIFS (samba) or NFS, I wouldn't worry too much. Most
distro's usually do a shutdown of services before they stop the local
filesystems and raid array so any 'loss' of data is usually caused by
a user who hasn't saved their files before the server went offline.
Once the clients have been disconnected, the shutdown should handle
stopping the raid array just fine.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
