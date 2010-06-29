From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID5 write hole?
Date: Tue, 29 Jun 2010 08:23:35 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1006290822470.8623@uplift.swm.pp.se>
References: <20100626143125.GA1010@localhost> <4C27290D.6000609@xs4all.nl> <20100627221613.0c34c812@notabene.brown> <20100629061634.GA20532@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100629061634.GA20532@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Shaochun Wang <scwang@ios.ac.cn>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Jun 2010, Shaochun Wang wrote:

> How do I know whether my RAID5 has wirte-intent bitmap enabled?

$ cat /proc/mdstat | grep bitmap
       bitmap: 0/8 pages [0KB], 131072KB chunk

If you don't get any bitmap information in there, it's not enabled.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
