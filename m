From: Derek Vadala <derek@cynicism.com>
Subject: Re: raidtab -> mdadm conf file?
Date: Wed, 19 Feb 2003 16:07:38 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030219210738.A074E3B82A@jaded.cynicism.com>
References: <20030219205621.GE13439@rdlg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030219205621.GE13439@rdlg.net>
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 19 Feb 2003, Robert L. Harris wrote:

> What should the output of "mdadm --detail --scan" look like?
>
> root@disk2:~# mdadm --detail --scan
> mdadm: option s not valid in mode D
>

A series of array entries like such (one for each array that's running):

ARRAY /dev/md0 level=raid1 num-devices=2 UUID=8b9bafc6:ed98bbd6:83d1c10f:d388a65f
ARRAY /dev/md6 level=raid1 num-devices=2 UUID=98079ef1:26a71e58:a91327d9:ada25de7
etc....

Which version of mdadm are you working with?

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

