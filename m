From: mike_rothon <mfr@supanet.com>
Subject: Re: hostRAID, AIC-7901, disable?
Date: Thu, 17 Mar 2005 09:05:26 +0000
Message-ID: <d1bh6i$vfk$1@sea.gmane.org>
References: <cpkem3$70s$1@sea.gmane.org>      <bbfa52890412131309234b2d09@mail.gmail.com>       <cpl0tm$4sp$1@sea.gmane.org>      <1103132961.3629.41.camel@compaq-rhel4.xsintricity.com> <32897.194.153.181.92.1103661695.squirrel@mail.valli.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <32897.194.153.181.92.1103661695.squirrel@mail.valli.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> We had the same problem with the adaptec 39320 in a Dell Server.
> The proper driver for the adaptec U320 scsi should be aic79xx
> and it really is.
> The aic79xx driver of the Kernel 2.4.28 didn't recognise
> our scsi adapter. So we downloaded one from adaptec which
> was labeled as *minimally tested*, but this one works:
> http://download.adaptec.com/scsi/linux/aic7Yxx-2.0.12-6.3.9-linux-2.4.tar.bz2
> or for kernel 2.6 series
> http://download.adaptec.com/scsi/linux/aic7Yxx-2.0.12-6.3.9-linux-2.6.tar.bz2

Did these updated modules work with HostRAID enabled? I haven't been sucessful 
in compiling them yet, which version of SuSE do you have?

> This tarballs contain the source for following drivers:
> aic79xx (version 2.0.12)
> aic7xxx (version 6.3.9)
> They are more recent than the original ones in the kernel.
> 
> If you don't like kernel-compiling there's a chance to find
> a precompiled one on sites like
> http://www.adaptec.com/worldwide/support/drivers_by_product.jsp?sess=no&language=English+US&prodkey=ASC-39320D-R&cat=%2fProduct%2fASC-39320D-R
> 

Strangely all the pre-compiled modules are for SuSE 8.0 and 8.2. There is one 
for 9.0, but it still has a 2.4 kernel. SuSE have released an update for SLES9, 
but of course its a different kernel variant and doesen't work with SL9.2 :-(.


>>Has anyone come across a solution? Is there a driver I don't know of?
>>Is there a way of disabling hostRAID?

Did you find an answer to this? I have searched and searched the BIOS, the 
technical docs, and the web and have no solutions.

