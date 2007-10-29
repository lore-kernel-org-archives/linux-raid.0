From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sun, 28 Oct 2007 20:48:35 -0400
Message-ID: <47252DE3.5090105@tmr.com>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org>	 <1192810534.1666.68.camel@firewall.xsintricity.com>	 <18200.56684.14194.630264@stoffel.org>	 <1192813877.1666.79.camel@firewall.xsintricity.com>	 <18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com>	 <1193184555.10336.3.camel@firewall.xsintricity.com>	 <18207.56169.769976.512617@notabene.brown>	<471FDEB1.8040401@garzik.org>	 <47204F45.4010205@dgreaves.com> <18209.34365.375059.602828@notabene.brown>	 <4721F742.1090301@tmr.com>	 <1193424116.10336.281.camel@firewall.xsintricity.com> <1193519471.10336.359.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193519471.10336.359.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Fri, 2007-10-26 at 14:41 -0400, Doug Ledford wrote:
>   
>> Actually, after doing some research, here's what I've found:
>>     
> I should note that both the lvm code and raid code are simplistic at the
> moment.  For example, the raid5 mapping only supports the default raid5
> layout.  If you use any other layout, game over.  Getting it to work
> with version 1.1 or 1.2 superblocks probably wouldn't be that hard, but
> getting it to the point where it handles all the relevant setups
> properly would require a reasonable amount of coding.
>
>   
My first thought is that after the /boot partition is read (assuming you 
use one) restrictions go away. Performance of /boot is not much of an 
issue, for me at least, but more complex setups are sometimes need for 
the rest of the system.

Thanks for the research.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

