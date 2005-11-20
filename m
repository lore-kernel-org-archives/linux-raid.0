From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: comparing FreeBSD to linux
Date: Sun, 20 Nov 2005 14:52:14 +0200
Message-ID: <5d96567b0511200452k10067acn1156081f654815f0@mail.gmail.com>
References: <5d96567b0511200350x215f37a1r5185d7b188f37639@mail.gmail.com>
	 <Pine.LNX.4.58.0511201258150.30165@lajli.gau.hu>
	 <5d96567b0511200404t52745c99u1a113014532cadce@mail.gmail.com>
	 <Pine.LNX.4.58.0511201341530.30165@lajli.gau.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0511201341530.30165@lajli.gau.hu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lajber Zoltan <lajbi@lajli.gau.hu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i have an intel ich6 ide controller chipset revision 3.
this is the obnly chipset i found in dmesg.

On 11/20/05, Lajber Zoltan <lajbi@lajli.gau.hu> wrote:
> Hi,
>
> On Sun, 20 Nov 2005, Raz Ben-Jehuda(caro) wrote:
>
> > I am using sata maxtor disks over raid0. i am using
> > 2.6.6 kernel.
> > What do u mean by "good kernel" ?
>
> Good kernel: apropriate driver for your disk driver. Wich sata chipset do
> you have?
> The 2.6.6 is rather old, go with recent kernel.
>
> raid0 has very low overhead, compared to raid1 or raid5. I haven o mora
> than 5% cpu on raid1 on a good motherboard.
>
> Bye,
> -=Lajbi=----------------------------------------------------------------
>  LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
>  Most of the time, if you think you are in trouble, crank that throttle!
>


--
Raz
