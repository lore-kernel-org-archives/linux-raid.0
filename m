From: Selim Daoud <selim.daoud@gmail.com>
Subject: Multipath
Date: Tue, 26 Jul 2005 16:30:13 +0100
Message-ID: <d01c0b6205072608305de15a6f@mail.gmail.com>
Reply-To: Selim Daoud <selim.daoud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to configure multipath on a Sun SE3510FC (fibre channel)
the configuration wiht mdadm works fine and I can see or manipulat both path.
unfortunately as soon as I mount the md device, md_multipathd process
takes 99% of CPU and at some point, server is not accessible anymore
it's SUSE9SP2, with qlogic 2342 HBAs

Is the multipath really working or is it still under early dev?. This
is supposed to be running Oracle DB (production system) for my company
..do you reckon we can rely on this mutipathing at this point in time
or is it better to wait?

thanks

Selim
