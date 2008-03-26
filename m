From: Luca Berra <bluca@comedia.it>
Subject: Re: MDP major registration
Date: Wed, 26 Mar 2008 07:52:32 +0100
Message-ID: <20080326065232.GA21970@percy.comedia.it>
References: <47D90614.9040206@free.fr> <18408.36753.223347.129420@notabene.brown> <47E92EE2.1080108@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E92EE2.1080108@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 25, 2008 at 05:57:06PM +0100, Hubert Verstraete wrote:
>Neil Brown wrote:
>>On Thursday March 13, hubskml@free.fr wrote:
>>>Neil,
>>>
>>>What is the status of the major for the partitionable arrays ?
>>
>>automatically determined at runtime.
>>
>>>I see that it is 254, which is in the experimental section, according to 
>>>the official Linux device list (http://www.lanana.org/docs/device-list/).
>>>Will there be an official registration ?
>>
>>No. Is there any need?
>
>I got this question in mind when I saw that mkfs.xfs source code was 
>referring to the MD major to tune its parameters on an MD device, while 
>it ignores MDP devices.
>If there were reasons to register MD, wouldn't they apply to MDP too ?

i don't think so:
bluca@percy ~ $ grep mdp /proc/devices
253 mdp

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
