From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Wed, 11 Nov 2009 00:01:49 -0700
Message-ID: <200911110001.49910.tfjellstrom@shaw.ca>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?iso-8859-1?q?Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue November 10 2009, you wrote:
> Hi,
> 
> I'm looking to replace a problematic Marvell PCIe SAS JBOD controller
> from Supermicro, type AOC-SASLP-MV8. (mdadm freaks out on it and the
> controller drops the drives - there has been discussion of the problem
> on the list. Seems to be a mvsas driver problem but seems to surface
> only under mdadm use.)
> 
> It's a nice controller, but we have to get an array going, so I'm
> shelving the Marvell card and getting a new one. I'll be using mdadm
> raid5 / raid6 over the controller.
> 
> This one, LSI SAS 3081E-R, looks good with eight SAS ports for around
>  $200:
>  http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas
> /internal/sas3081e-r/index.html
> 
> I can't find anything concrete regarding Linux, but I did find a
> known-good confirmation for Solaris/ZFS here:
> http://jmlittle.blogspot.com/2008/06/recommended-disk-controllers-for-zfs
> .html
> 
> Can anyone confirm/deny that the PCIe JBOD controllers from LSI work
> on Linux out of the box? Or give other recommendations for 8 port
> controllers in the $150-$200 range? (Or thereabouts. It'd be great to
> know about any known-good 4-port controllers for even up to $250.)
> 
> Thanks!

Not really an answer to your question, I got a snapshot of the in 
development driver that seems to work just fine. I haven't run smartctl on 
the controller much mind you, as it seems to freak out my onboard controller 
too (AMD SB750). I could attempt it, but I've recently just switched over to 
that hardware for my main server, and I'm reluctant to try running smartctl 
on the array, as it'd probably require a reboot to get which ever disk back 
that might get dropped.

I might try it later, but I don't even have smartmontools installed.

> -- Kristleifur
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
