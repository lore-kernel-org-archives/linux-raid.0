From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID 5 On Linux
Date: Fri, 25 Jul 2003 12:21:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16160.37915.55072.524606@gargle.gargle.HOWL>
References: <16160.34422.833142.148043@gargle.gargle.HOWL>
	<35005.202.158.96.2.1059099261.power.web.id@mail2.oke.net.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from c4c3m@oke.net.id on Friday July 25
To: c4c3m@oke.net.id
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 25, c4c3m@oke.net.id wrote:
> i did it what u say. i was install mdadm from other machine and loat it on
> faulty machine. but another  error show up (mdadm: /lib/libc.so.6: version
> 'GLIBC_2.2.3' not found (required by mdadm)).
> i'm using red hat 6.2 and when i try to check the files (libc.so.6)...it was
> there...what should i do ???
> note:
> * i can't access /usr and /var partition
> 

You can build a statically linked mdadm with

   make mdadm.static

if you copy this across to your faulty machine, it should run without
needing to find any libraries.

NeilBrown
