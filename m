From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: raid1 with nbd member hangs MD on SLES10 and RHEL5
Date: Thu, 14 Jun 2007 21:00:44 -0400
Message-ID: <4671E4BC.9080806@steeleye.com>
References: <170fa0d20706121930g3b89ddeex8b31c8923d2a0ff6@mail.gmail.com>	 <18031.22930.243723.550238@notabene.brown>	 <170fa0d20706121959w480213bcvaba1b6881710379f@mail.gmail.com>	 <170fa0d20706122009h5e3db54ek7487be4940a3d780@mail.gmail.com>	 <18031.25581.353761.802283@notabene.brown>	 <170fa0d20706122130q2c77d365tbe9261bab1a5b1b@mail.gmail.com>	 <170fa0d20706131123q17e4fb9ehe6be25a07462cc30@mail.gmail.com> <170fa0d20706131630p6cd29aa5i8f51856780a9c691@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20706131630p6cd29aa5i8f51856780a9c691@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: linux-raid.ids

Mike Snitzer wrote:

> Just a quick update; it is really starting to look like there is
> definitely an issue with the nbd kernel driver.  I booted the SLES10
> 2.6.16.46-0.12-smp kernel with maxcpus=1 to test the theory that the
> nbd SMP fix that went into 2.6.16 was in some way causing this MD/NBD
> hang.  But it _still_ occurs with the 4-step process I outlined above.
> 
> The nbd0 device _should_ feel an NBD_DISCONNECT because the nbd-server
> is no longer running (the node it was running on was powered off)...

What do you mean, nbd should _feel_ an NBD_DISCONNECT ?

NBD_DISCONNECT is a manual process, not an automatic one.

--
Paul
