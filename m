From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Fri, 13 Nov 2009 00:02:04 +0100
Message-ID: <4AFC93EC.2070403@grumpydevil.homelinux.org>
References: <200911121751.nACHpMrQ011365@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911121751.nACHpMrQ011365@wind.enjellic.com>
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: Neil F Brown <nfbrown@novell.com>, Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

greg@enjellic.com wrote:
> On Nov 10,  7:22am, "Neil F Brown" wrote:
> } Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
>
> Good morning to everyone, hope the week is progressing well.
>
> <snip>
> It may be heresy but I would suggest that if the defaults change we
> should also implement support for auto-starting version 1.x devices,
> or some appropriate subset of them.
>
> I understand and appreciate the concerns of the userspace start
> community.  However, we do a lot of storage on very dedicated systems
> and I have spent far more time unsnarling systems with blown
> initrd/initramfs setups and other boot issues than I have recovering
> from starting RAID volumes on the wrong box.  Thats why I don't let
> udev anywhere near production machines and I am still living on 0.9
> metadata in spite of its limitations.
>
> UNIX has always been about allowing people to shoot themselves in the
> foot if they so desire.  I think an acceptable compromise would be to
> move toward a default of disabled auto-detection with the option to
> turn on detection of all meta-data types if people choose to do that.
>
>   
+1


Cheers,

Rudy
