From: Chris Green <cgreen@valvesoftware.com>
Subject: RE: NAS Remote Side of a Mirror
Date: Wed, 7 Oct 2009 17:50:32 -0700
Message-ID: <4D87015385157D4285D56CA6101072FF2CB51276@exchange07.valvesoftware.com>
References: <905067.19304.qm@web38806.mail.mud.yahoo.com>
 <130273.20896.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <130273.20896.qm@web38804.mail.mud.yahoo.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: 'adfas asd' <chimera_god@yahoo.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Why do you think samba would be a bad choice? I did a quick search for qnap benchmarks, and the numbers didn't look
like anything special compared to my "generic pc + linux + software raid + samba + gbE" setup.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of adfas asd
Sent: Wednesday, October 07, 2009 4:49 PM
To: linux-raid@vger.kernel.org
Subject: Re: NAS Remote Side of a Mirror

OK, say I wanted to build this remote NAS box myself, rather than spending $750 for a Qnap. (http://qnap.com/pro_detail_feature.asp?p_id=110)  I find a good case, power supply, micro mobo, and cage, and install Linux and NX (remote desktop) on it.
 
I need to share those drives over GbE with minimal software intervention. I'm not about to use bloatware like NFS or Samba. And sshfs or an SSH tunnel could not keep up the speeds I'd need. How do you suppose Qnap shares those drives? And provides all those other services?
 
So looking at Qnap's update, it comes down as a disk img file, which I can not mount in loopback. Probably encrypted, and knowing them in AES256.

Anyone built a remote NAS box?  How to share those drives with minimal software intervention?



--- On Mon, 10/5/09, adfas asd <chimera_god@yahoo.com> wrote:

> From: adfas asd <chimera_god@yahoo.com>
> Subject: NAS Remote Side of a Mirror
> To: linux-raid@vger.kernel.org
> Date: Monday, October 5, 2009, 8:37 AM
> I'm looking at setting up my RAID
> mirrored array so that one side of the mirror is in the HTPC
> and the other is NASsed in the garage, in case of theft or
> fire.
> 
> I am concerned about the boot process though, as the NASsed
> side will not be available until the network comes up. 
> Will the array be able to be patient for that and include
> that side once it comes up, and run not degraded?
> 
> What if I lose my local side of the mirror?  Is
> failover possible to the NAS side?  (Assuming a
> separate boot disk with everything except /home, which is on
> the array)
> 
> The only other technology I am aware of which can remote
> drives at distance is fibrechannel, and that's too
> expensive, so it seems I'm stuck with GB ethernet.  Are
> there in fact any other options?
> 
> Is it possible to bring up ethernet early in the boot
> process with initrd.img?
> 
> Has anyone actually done any of this?
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
