From: Alex Butcher <linraid@assursys.co.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Wed, 16 Sep 2009 14:05:24 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0909161404100.9530@sbhezbfg.of5.nffheflf.cev>
References: <h8nbt5$n8p$1@ger.gmane.org> <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>  <h8nrkn$n8p$5@ger.gmane.org> <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>  <70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
  <1253037953.7774.131.camel@kiste> <70ed7c3e0909151114q7296314du77de369f5e4ea695@mail.gmail.com>  <1253040282.7774.149.camel@kiste> <70ed7c3e0909160231l4e424ff3y4d4615ebb87c0e82@mail.gmail.com>  <1253094266.6394.5.camel@localhost>
 <70ed7c3e0909160252l72ffb28dw1dd6315dad1985a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909160252l72ffb28dw1dd6315dad1985a5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Matthias Urlichs <matthias@urlichs.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Sep 2009, Majed B. wrote:

> I wrote zeros to the disk yesterday and both Pending and Offline counts
> have been reset, but Reallocation count didn't increase.

Soft, rather than hard errors, presumably. These can occur if a drive is
writing when power is unexpectedly removed.

HTH,
Alex
