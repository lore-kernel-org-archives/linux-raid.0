From: Luca Berra <bluca@comedia.it>
Subject: Re: [Fwd: Re: Multipath problem [zero Block multipath device creation with mdadm 1.8.1]]
Date: Thu, 25 Nov 2004 19:53:37 +0100
Message-ID: <20041125185336.GB16618@percy.comedia.it>
References: <41A5E9C0.9050000@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41A5E9C0.9050000@fbihome.de>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Heinz <oheinz@fbihome.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 25, 2004 at 03:18:40PM +0100, Oliver Heinz wrote:
>As  the linux-raid list seems to have some problems at the moment, I 
>take the chance to thank you personally an send you a copy of the reply 
>I submitted some hours ago.
>
>Thanks again + Bye,
>Oliver

>Date: Thu, 25 Nov 2004 10:43:53 +0100
>From: Oliver Heinz <oheinz@fbihome.de>
>User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.7.3) Gecko/20041007 Debian/1.7.3-5
>CC:  linux-raid@vger.kernel.org
>Subject: Re: Multipath problem [zero Block multipath device creation with
> mdadm 1.8.1]
>In-Reply-To: <20041123201650.GA8972@percy.comedia.it>
>
>Luca Berra schrieb:
>
>>On Tue, Nov 23, 2004 at 01:19:51PM +0100, Oliver Heinz wrote:
>>
>>>Mixing mdadm-1.6 and 1.8.1 for creating/managing the device doesn't 
>>>work, it gives me an segfault.
>>
>>
>>try patching mdadm-1.8.1 with this patch, it might help with the
>>segfault.
>
>This works! Thanks a lot!

great.

>
>Now creating the md-device with versions prior 1.8.1 works (I tested 
>1.60 and 1.8.0) - restarting the array with them fails.
>With 1.8.1 (with patch applied) I get an 0 Block device created bit I 
>can restart the (correct) device I created with 1.60.

1.8.1 changed the way devices get created, i did not have any chance to
test it with multipath yet.
see the changelog for more information.

>Now of course it would be great to get the device created and restarted 
>with the same utility. We'd like to use it in production environment 
>here, can more experienced mdadm users recommend that, these problems  
>did not really strengthen our confidence in mdadm (at least when it 
>comes to multipath, we have (of course) been using mdadm successfully 
>for raid on severall systems).
>
>Are the code changes in 1.8.1 so drastic that you would recommend to 
>stick with prior versions and fix the issue with starting the array or 
1.8.1 is considered a development version, not ready for production.

>would you suggest to get 1.8.1 to get MD creation in 1.8.1 fixed (well 
>it need's to be fixed anyway ;-).

it needs to be fixed.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
