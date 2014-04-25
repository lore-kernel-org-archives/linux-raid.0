From: Jeff Wiegley <jeffw@csun.edu>
Subject: Re: Why would a recreation cause a different number of blocks??
Date: Thu, 24 Apr 2014 23:45:48 -0700
Message-ID: <535A049C.1010801@csun.edu>
References: <20140424070548.445497dd@netstation> <20140424194832.2d0a867f@netstation> <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com> <20140424203506.5fdee0d3@netstation> <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail <53598F69.5070700@csun.edu> <alpine.DEB.2.02.1404250533040.19744@uplift.swm.pp.se> <5359EC4D.7000308@csun.edu> <alpine.DEB.2.02.1404250800190.19744@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404250800190.19744@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

ooooh... Making progress.

I downloaded and compiled mdadm-3.1.4 and used that to create
the array.

The size is the same and luksOpen recognizes it as luks and
asks for and accepts the passphrase.

however mount says it need to be told the filesystem type and
if I add -t xfs then it still fails to mount the filesystem.

Any thoughts why the recreated array would satisfy and pass
cryptsetup's sanity checks but the resulting decrypted data
is not recognizable as xfs?

- Jeff

On 4/24/2014 11:01 PM, Mikael Abrahamsson wrote:
> On Thu, 24 Apr 2014, Jeff Wiegley wrote:
>
>> If it's mdadm then could I just grab old copies of mdadm sources and
>> compile them one version after the other and try each one?
>
> As far as I know, it's mdadm version specific. If you look in the archives
> I'm sure you'll be able to find the old offsets and you can use the latest
> mdadm with those offsets and hopefully things will work.
>

