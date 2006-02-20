From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Avoiding resync of RAID1 during creation
Date: Mon, 20 Feb 2006 23:07:15 +0200
Message-ID: <5b170a7d0602201307n548d006brf34db19b19a30323@mail.gmail.com>
References: <43F9E65D.6040402@datafoundry.com>
	 <5b170a7d0602201227p5cb458a5j13aecca21aa3d627@mail.gmail.com>
	 <43FA2BE9.6010804@datafoundry.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43FA2BE9.6010804@datafoundry.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Wann <bryan@datafoundry.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/20/06, Bryan Wann <bryan@datafoundry.com> wrote:
> > mdadm --assume-clean
> >
> What version of mdadm was that from?  From mdadm(8) in
> mdadm-1.11.0-4.fc4 on my systems:
>
<cut>
> I tried with --assume-clean, it still wanted to sync.

The man page i quoted was from 2.3.1 (6 feb) - relatively new.

I tested this with 2 boxes: 1.9.0 starts the resync and 2.3.1 doesn't.
Used kernel 2.6.14 - altough I don't expect that to make much of a
difference.

-tuomas
