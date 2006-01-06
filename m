From: PFC <lists@peufeu.com>
Subject: Re: Kanotix crashed my raid...
Date: Fri, 06 Jan 2006 23:01:16 +0100
Message-ID: <op.s2y8sekvcigqcu@apollo13>
References: <fd8d0180601050104x15079396h@mail.gmail.com> <fd8d0180601050106s5f5b4306o@mail.gmail.com> <87oe2r2d93.fsf@rimspace.net> <fd8d0180601050321k19f12f53r@mail.gmail.com> <43BE3C99.4050706@ieee.org> <op.s2yecmeocigqcu@apollo13> <op.s2yg1vkdcigqcu@apollo13> <op.s2yhczepcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s2yhczepcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	OK, I bit the bullet and removed the "goto abort" in raid5.c

	I was then able to mount everything and recover all of my data without  
any problem. Hm.

	There should be a way to do this with mdadm without recompiling the  
kernel, but anyway, opensource saved my ass xDDD
