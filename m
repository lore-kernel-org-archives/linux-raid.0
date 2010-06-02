From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Tue, 1 Jun 2010 23:08:52 -0700
Message-ID: <AANLkTinjHWth9B79IimV3g-U9CNUu1tHRiyf6Ya-7Yys@mail.gmail.com>
References: <AANLkTilamRIEvggIh7LX6sNNKwMJJVNK4gPuBQkGmkOv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilamRIEvggIh7LX6sNNKwMJJVNK4gPuBQkGmkOv@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 1, 2010 at 10:08 AM, Carlos Mennens <carloswill@gmail.com> wrote:
> I built a new home server this weekend & am ready to load my O.S.
> (Arch Linux) on it today. It has 4 x 320 GB Seagate Barracuda's
> (SATA). I don't really have a specific function of this server at home
> beyond holding my data reliably and decent read / write performance.
> My question to you experts is what do you recommend I configure for
> this particular configuration? Should I run RAID 5 or RAID 10? To
> spare or not to spare? I really appreciate any best suggestions for
> general over all function on this matter.

How about 2 drives in a RAID0 or LVM configuration and the other two
in another machine and used for backups?

Simon
