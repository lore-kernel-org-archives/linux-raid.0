From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: When does a disk get flagged as bad?
Date: Fri, 01 Jun 2007 20:07:56 -0400
Message-ID: <4660B4DC.1080408@tmr.com>
References: <5822.1180578498@mdt.dhcp.pit.laurelnetworks.com>	<1180579742.20508.18.camel@w100> <18014.26329.836246.525012@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18014.26329.836246.525012@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alberto Alonso <alberto@ggsys.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday May 30, alberto@ggsys.net wrote:
>   
>> After thinking about your post, I guess I can see some logic behind
>> not failing on the read, although I would say that after x amount of
>> read failures a drive should be kicked out no matter what.
>>     
>
> When md gets a read error, it collects the correct data from elsewhere
> and tries to write it to the drive that apparently failed.
> If that succeeds, it tries to read it back again.  If that succeeds as
> well, it assumes that the problem has been fixed.  Otherwise it fails
> the drive.
>   
That's the way it should work, but hopefully the error is logged 
somewhere. Other than as a SMART relocate?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

