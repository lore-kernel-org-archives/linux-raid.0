From: Lewis Shobbrook <mylists@blue-matrix.org>
Subject: Re: Raid5 & Debian Yaird Woes
Date: Sat, 4 Feb 2006 09:58:17 +1100
Message-ID: <200602040958.20183.mylists@blue-matrix.org>
References: <200602031229.37972.mylists@blue-matrix.org> <Pine.LNX.4.64.0602021808100.6557@twinlark.arctic.org> <Pine.LNX.4.64.0602021859490.15679@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0602021859490.15679@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org, dr@jones.dk
List-Id: linux-raid.ids

On Friday 03 February 2006 2:02 pm, you wrote:

Hi Dean,
Thanks for the suggestions.
> On Thu, 2 Feb 2006, dean gaudet wrote:
> > i've never looked at yaird in detail -- but you can probably use
> > initramfs-tools instead of yaird...
>
> i take it all back... i just tried initramfs-tools and it failed to boot
> my system properly... whereas yaird almost got everything right.
>
> the main thing i'd say yaird is doing wrong is that it is specifying the
> root raid devices explicitly rather than allowing mdadm to scan the
> partitions list and assemble by UUID...
>
> maybe try the patch below on your yaird configuration and then run:
>
> 	dpkg-reconfigure linux-image-`uname -r`
>
> which will rebuild your initrd with this change... then see if it survives
> your boot testing.
>
> -dean
>
> p.s. this patch has been submitted to debian bugdb...
>
> --- /etc/yaird/Templates.cfg	2006/02/03 02:44:49	1.1
> +++ /etc/yaird/Templates.cfg	2006/02/03 02:46:15
> @@ -299,8 +299,7 @@
>  		SCRIPT "/init"
>  		BEGIN
>  			!mknod <TMPL_VAR NAME=target> b <TMPL_VAR NAME=major> <TMPL_VAR
> NAME=minor> -			!mdadm --assemble <TMPL_VAR NAME=target> --uuid <TMPL_VAR
> NAME=uuid> \ -			!	<TMPL_LOOP NAME=components> <TMPL_VAR
> NAME=dev></TMPL_LOOP>
> +			!mdadm -Ac partitions <TMPL_VAR NAME=target> --uuid <TMPL_VAR
> NAME=uuid> END SCRIPT
>  	END TEMPLATE

I applied the patch as well as modified the mdadm.conf, as you suggested in 
the previous email, and the system restarted without problem! 
A positive step forward.
Removing a drive however, results in a disruption to the boot process 
requiring user input (ctrl D) in the admin console to kick things off again.  
Notably it works from this point, where previously I had encountered kernel 
panic.
Is there any way to avoid this requirement for input, so that the system skips 
the missing drive as the raid/initrd system did previously?  
If you have a system restart after a power outage combined with a degraded 
array, the server would be unacceptably kept offline until manual 
intervention occurred.

Cheers & Thanks,

Lewis
