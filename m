From: dean gaudet <dean@arctic.org>
Subject: Re: USB and raid... Device names change
Date: Mon, 18 Sep 2006 16:43:27 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609181641530.30771@twinlark.arctic.org>
References: <7.0.1.0.0.20060919000021.03151fd8@kender.es>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7.0.1.0.0.20060919000021.03151fd8@kender.es>
Sender: linux-raid-owner@vger.kernel.org
To: Eduardo Jacob <edu@kender.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Sep 2006, Eduardo Jacob wrote:

> DEVICE /dev/raid111 /dev/raid121
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=1369e13f:eb4fa45c:6d4b9c2a:8196aa1b

try using "DEVICE partitions"... then "mdadm -As /dev/md0" will scan all 
available partitions for raid components with 
UUID=1369e13f:eb4fa45c:6d4b9c2a:8196aa1b.  so it won't matter which sdX 
they are.

-dean
