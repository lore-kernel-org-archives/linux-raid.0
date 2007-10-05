From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Journalling filesystem corruption fixed in between?
Date: Fri, 05 Oct 2007 11:51:17 -0400
Message-ID: <47065D75.7040802@tmr.com>
References: <735D322AED9CD711BE53000476917CD0029728C3@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <735D322AED9CD711BE53000476917CD0029728C3@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rustedt, Florian wrote:
> Hello list,
>
> some folks reported severe filesystem-crashes with ext3 and reiserfs on
> mdraid level 1 and 5.
>
> Is this safe now? Or should i only use non-journalling-filesystems on
> software-raid-devices?
>   

I have been using swRAID since it was an experimental patch, and haven't 
seen any indication that this is true. Clearly any f/s will be subject 
to error on bad hardware.

Sounds like an urban myth to me!

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

