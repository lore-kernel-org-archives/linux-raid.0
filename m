From: Asdo <asdo@shiftmail.org>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Wed, 27 Jan 2010 11:50:07 +0100
Message-ID: <4B601A5F.9050301@shiftmail.org>
References: <4B5F6C73.30707@texsoft.it> <4B6000F0.2000405@shiftmail.org>
 <4B6010F5.6030702@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B6010F5.6030702@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giovanni Tessore wrote:
> I didn't setup smart monitoring... Luca is right.
> But I dont like the idea that md relies on another tool, that could be 
> not installed or correctly configured, to warn the user on potential 
> critical situations which involve directly itself.
>
> From the logs, it results that it did a "check" on md3 the 4 january 
> (first read errors at beginning of december, failure of other disk 18 
> january); no read error occurred.
> Looks like it did not help much :(
> Maybe I was just very unluky 

It's strange... quite unlucky I'd say...
Maybe the check needs to be run more frequently, like weekly.
(Asdo taking notes... :-D)
I also am not expert of this kind of statistics.
FWIW I have seen two hardware raid controllers, and they do the scrub 
weekly by default. I don't know if they also run SMART tests.

Also is it possible that you experienced an electricity surge or a 
physical shock on the computer?

Obviously smart checks also help.

Good luck
Asdo
