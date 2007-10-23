From: Michal Soltys <nozo@ziu.info>
Subject: Re: chunk size (was Re: Time to deprecate old RAID formats?)
Date: Tue, 23 Oct 2007 21:21:54 +0200
Message-ID: <471E49D2.9070608@ziu.info>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org>	 <1192810534.1666.68.camel@firewall.xsintricity.com>	 <18200.56684.14194.630264@stoffel.org>	 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>	 <18200.57042.989520.666476@stoffel.org>	 <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>	 <1192813477.1666.74.camel@firewall.xsintricity.com>	 <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan>	 <1192814581.1666.87.camel@firewall.xsintricity.com>	 <47193314.5010606@ziu.info> <1192886944.1666.124.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192886944.1666.124.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

Doug Ledford wrote:
> 
> Well, first I was thinking of files in the few hundreds of megabytes
> each to gigabytes each, and when they are streamed, they are streamed at
> a rate much lower than the full speed of the array, but still at a fast
> rate.  How parallel the reads are then would tend to be a function of
> chunk size versus streaming rate. 

Ahh, I see now. Thanks for explanation.

I wonder though, if setting large readahead would help, if you used larger 
chunk size. Assuming other options are not possible - i.e. streaming from 
larger buffer, while reading to it in a full stripe width at least.

> 
> I'm not familiar with the benchmark you are referring to.
> 

I was thinking about 
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08461.html

with small discussion that happend after that.
